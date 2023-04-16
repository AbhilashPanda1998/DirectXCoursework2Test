static float nearPlane = 1.0;
static float farPlane = 1000.0;

// A constant buffer that stores the three basic column-major matrices for composing geometry.
cbuffer modelViewProjectionConstantBuffer : register(b0)
{
	matrix model;
	matrix view;
	matrix projection;
	float4 eye;
	float4 lookAt;
	float4 upDir;
};

struct Ray
{
	float3 origin;
	float3 direction;
};

struct VS_QUAD
{
	float4 position : SV_POSITION;
	float2 canvasXY : TEXCOORD0;
};

struct PixelShaderOutput
{
	float4 colour : SV_TARGET;
	float depth : SV_DEPTH;
};

static PixelShaderOutput output;

float2 opU(float2 d1, float2 d2)
{
	return (d1.x < d2.x) ? d1 : d2;
}

//------------------------------------------------------------------

#define ZERO 0

float2 coral(float3 pos) {
	float n = 8.0;
	float t0 = 1.0;
	float dr = 1.0;

	float r, phi, theta, l;

	float3 z = pos;

	for (int i = 0; i < 6; i++)
	{
		r = length(z);

		if (r > 2.0)continue;

		phi = atan(z.y / z.x);
		theta = asin(z.z / r);

		dr = pow(r, n - 1.0)*dr *n + 5.0;

		z = pow(r, n)*float3(cos(n*theta * 3.f)*cos(n*phi), sin(n*theta)*sin(n*phi), sin(n*theta)) + pos;
		t0 = min(r, t0);
	}
	return float2(r*log(r) / dr / 2.0, t0);
}

float2 map(in float3 inPos)
{
	float3 pos = inPos;
	float2 res = float2(1e10, 0.0);
	
    res = opU(res, coral(pos - float3(0, 2, -5)));

	return res;
}

float2 iBox(in float3 ro, in float3 rd, in float3 rad)
{
	float3 m = 1.0 / rd;
	float3 n = m * ro;
	float3 k = abs(m)*rad;
	float3 t1 = -n - k;
	float3 t2 = -n + k;
	return float2(max(max(t1.x, t1.y), t1.z),
		min(min(t2.x, t2.y), t2.z));
}

const float maxHei = 0.8;

float2 castRay(in float3 ro, in float3 rd)
{
	float2 res = float2(-1.0, -1.0);

	float tmin = 1.0;
	float tmax = 20.0;

	// raymarch primitives   
    float2 tb = iBox(ro, rd, float3(500, 500, 500));
	if (tb.x<tb.y && tb.y>0.0 && tb.x < tmax)
	{
		tmin = max(tb.x, tmin);
		tmax = min(tb.y, tmax);

		float t = tmin;
		for (int i = 0; i < 55 && t < tmax; i++)
		{
			float2 h = map(ro + rd * t);
			if (abs(h.x) < (0.00001*t))
			{
				res = float2(t, h.y);
				break;
			}
			t += h.x;
		}
	}

	return res;
}


float calculateSoftShadow(in float3 ro, in float3 rd, in float mint, in float tmax)
{
	float tp = (maxHei - ro.y) / rd.y; if (tp > 0.0) tmax = min(tmax, tp);

	float res = 1.0;
	float t = mint;
	for (int i = ZERO; i < 16; i++)
	{
		float h = map(ro + rd * t).x;
		res = min(res, 2.0*h / t);
		t += clamp(h, 0.02, 0.10);
	}
	return clamp(res, 0.0, 1.0);
}

float3 calcNormal(in float3 pos)
{
	float2 e = float2(1.0, -1.0)*0.5773*0.0005;
	return normalize(e.xyy*map(pos + e.xyy).x +
		e.yyx*map(pos + e.yyx).x +
		e.yxy*map(pos + e.yxy).x +
		e.xxx*map(pos + e.xxx).x);  
}

float calculateAmbientOcclusion(in float3 pos, in float3 nor)
{
	float occ = 0.0;
	float sca = 1.0;
	for (int i = ZERO; i < 5; i++)
	{
		float hr = 0.01 + 0.12*float(i) / 4.0;
		float3 aopos = nor * hr + pos;
		float dd = map(aopos).x;
		occ += -(dd - hr)*sca;
		sca *= 0.95;
	}
	return clamp(1.0 - 3.0*occ, 0.0, 1.0) * (0.5 + 0.5*nor.y);
}

float3 renderObject(in float3 origin, in float3 direction)
{
    float3 color = float3(0.7, 0.9, 1.0) + direction.y * 0.8;
    float2 result = castRay(origin, direction);
    float t = result.x;
    float distance = result.x;
    float material = result.y;
    if (material > -0.5)
    {
        float3 position = origin + distance * direction;
        float4 depthPosition = mul(mul(float4(position, 1), view), projection);
        output.depth = depthPosition.z / depthPosition.w;
        float3 normal = (material < 1.5) ? float3(0.0, 1.0, 0.0) : calcNormal(position);
        float3 reflection = reflect(direction, normal);

        color = 0.45 + 0.35 * sin(float3(0.05, 0.08, 0.10) * (material - 1.0));
		
        float occlusion = calculateAmbientOcclusion(position, normal);
        float3 lightDirection = normalize(float3(-10, 100, -10));
        float3 halfVector = normalize(lightDirection - direction);
        float ambient = clamp(0.5 + 0.5 * normal.y, 0.0, 1.0);
        float diffuse = clamp(dot(normal, lightDirection), 0.0, 1.0);
        float backscattering = clamp(dot(normal, normalize(float3(-lightDirection.x, 0.0, -lightDirection.z))), 0.0, 1.0) * clamp(1.0 - position.y, 0.0, 1.0);
        float glossiness = smoothstep(-0.2, 0.2, reflection.y);
        float fresnel = pow(clamp(1.0 + dot(normal, direction), 0.0, 1.0), 2.0);

        diffuse *= calculateSoftShadow(position, lightDirection, 0.02, 2.5);
        glossiness *= calculateSoftShadow(position, reflection, 0.02, 2.5);

        float specular = pow(clamp(dot(normal, halfVector), 0.0, 1.0), 16.0) *
			diffuse *
			(0.04 + 0.96 * pow(clamp(1.0 + dot(halfVector, direction), 0.0, 1.0), 5.0));

        float3 lighting = float3(0.0, 0.0, 0.0);
        lighting += 1.30 * diffuse * float3(1.00, 0.80, 0.55);
        lighting += 0.30 * ambient * float3(0.40, 0.60, 1.00) * occlusion;
        lighting += 0.40 * glossiness * float3(0.40, 0.60, 1.00) * occlusion;
        lighting += 0.50 * backscattering * float3(0.25, 0.25, 0.25) * occlusion;
        lighting += 0.25 * fresnel * float3(1.00, 1.00, 1.00) * occlusion;
        color = color * lighting;
        color += 9.00 * specular * float3(1.00, 0.90, 0.70);

        color = lerp(color, float3(0.8, 0.9, 1.0), 1.0 - exp(-0.0002 * t * t * t));
    }
    else
    {
        discard;
    }

    return float3(clamp(color, 0.0, 1.0));
};


PixelShaderOutput main(VS_QUAD input)
{
	float zoomCam = 10.0;
    float2 xy = zoomCam * input.canvasXY;
	float distEyeToCanvas = nearPlane;
	float3 pixelPos = float3(xy, -distEyeToCanvas);

	Ray eyeRay;
	eyeRay.origin = eye.xyz;
	eyeRay.direction = normalize(pixelPos - eye.xyz);

    float3 pixelColour = renderObject(eyeRay.origin, eyeRay.direction);
	output.colour = float4(pixelColour, 1.0);
	return output;
}