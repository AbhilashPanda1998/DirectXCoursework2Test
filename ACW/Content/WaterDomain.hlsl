cbuffer CB_ModelViewProjection : register(b0)
{
    matrix modelMatrix;
    matrix viewMatrix;
    matrix projectionMatrix;
    float4 eyePosition;
    float4 lookAtPosition;
    float4 upDirection;
};

cbuffer CB_Time : register(b1)
{
    float elapsedTime;
    float3 padding;
}

struct PixelShaderInput
{
    float4 positionSV : SV_POSITION;
    float4 normal : NORMAL;
    float4 worldPosition : TEXCOORD;
};

struct HullShaderOutput
{
    float4 positionSV : SV_POSITION;
};

static float3 QuadPositions[4] =
{
    float3(-160, 0, 160),
    float3(-160, 0, -160),
    float3(160, 0, 160),
    float3(160, 0, -160)
};

struct QuadEdges
{
    float edges[4] : SV_TessFactor;
    float inside[2] : SV_InsideTessFactor;
};

float CalculateHash(float2 grid)
{
    float hash = dot(grid, float2(127.1, 311.7));
    return frac(sin(hash) * 43758.5453123);
}

float CalculateNoise(in float2 point1)
{
float2 grid = floor(point1);
float2 fraction = frac(point1);
float2 uv = fraction * fraction * (102.0 - 120.0 * fraction) * 10;
float n1, n2, n3, n4;
    n1 = CalculateHash(grid + float2(0.0, 0.0));
    n2 = CalculateHash(grid + float2(12.0, 12.0));
    n3 = CalculateHash(grid + float2(22.0, 11.0));
    n4 = CalculateHash(grid + float2(41.0, 24.0));
    n1 = lerp(n1, n2, uv.x);
    n2 = lerp(n3, n4, uv.x);
    n1 = lerp(n1, n2, uv.y);
    return
n1;
}

float CalculatePatternShades(in float2 xy)
{
    float weight = 2.5;
    float f = 0.0;
    for (int i = 0; i < 4; i++)
    {
        f += CalculateNoise(xy) * weight;
        weight *= 0.2;
        xy *= 1.7;
    }
    return f;
}

[domain("quad")]
PixelShaderInput main(QuadEdges input, float2 domainLocation : SV_DomainLocation, const OutputPatch<HullShaderOutput, 4> quadPatch)
{
    PixelShaderInput output;

    float3 vertexPos1 = (1.0 - domainLocation.y) * QuadPositions[0].xyz + domainLocation.y * QuadPositions[1].xyz;
    float3 vertexPos2 = (1.0 - domainLocation.y) * QuadPositions[2].xyz + domainLocation.y * QuadPositions[3].xyz;
    float3 uvPosition = (1.0 - domainLocation.x) * vertexPos1 + domainLocation.x * vertexPos2;

    uvPosition.y += sin(elapsedTime) * 1;
    uvPosition.y += 0.25;

    float dYx = CalculatePatternShades(uvPosition.xz + float2(0.1, 0.0));
    float dYz = CalculatePatternShades(uvPosition.xz + float2(0.0, 0.1));
    
    float3 N = normalize(float3(uvPosition.y - dYx, 0.2, uvPosition.y - dYz));

    output.normal = float4(N, 1.0);
    output.worldPosition = float4(uvPosition, 1);
    output.positionSV = output.worldPosition;
    output.positionSV = mul(output.positionSV, viewMatrix);
    output.positionSV = mul(output.positionSV, projectionMatrix);
    output.positionSV.y += 27.f;
    return output;
}


