cbuffer Transform : register(b0)
{
    matrix worldMatrix;
    matrix viewMatrix;
    matrix projectionMatrix;
    float4 cameraPosition;
    float4 cameraTarget;
    float4 cameraUpDirection;
};

cbuffer LightBuffer : register(b1)
{
    float4 lightPosition;
    float4 lightColor;
}

cbuffer Time : register(b2)
{
    float currentTime;
    float3 padding;
}

struct PSInput
{
    float4 position : SV_POSITION;
    float4 normal : NORMAL;
    float4 worldPosition : TEXCOORD;
};

float GetHash(float2 grid)
{
    float hash = dot(grid, float2(127.1, 311.7));
    return frac(sin(hash) * 43758.5453123);
}

float GetNoise(in float2 p)
{
    float2 grid = floor(p);
    float2 f = frac(p);
    float2 uv = f * f * (3.0 - 2.0 * f);
    float n1, n2, n3, n4;
    n1 = GetHash(grid + float2(0.0, 0.0));
    n2 = GetHash(grid + float2(1.0, 0.0));
    n3 = GetHash(grid + float2(0.0, 1.0));
    n4 = GetHash(grid + float2(1.0, 1.0));
    n1 = lerp(n1, n2, uv.x);
    n2 = lerp(n3, n4, uv.x);
    n1 = lerp(n1, n2, uv.y);
    return n1;
}

float GetPatternShades(in float2 xy)
{
    float weight = .7;
    float result = 0.0;
    for (int i = 0; i < 4; i++)
    {
        result += GetNoise(xy) * weight;
        weight *= 0.5;
        xy *= 2.7;
    }
    return result;
}

float4 main(PSInput input) : SV_TARGET
{
    float4 finalColor = 0;
    float4 diffuseColor = 0;
    float diffuseFactor = 0;
    float4 specularColor = 0;
    float specularFactor = 0;

    float4 ambientColor = float4(0.2, 0.2, 0.3, 1.0);
    float4 materialDiffuse = 0;
    float4 materialSpecular = 0;
    float4 textureColor = 0;

    materialDiffuse = float4(0.0, 0.6, 0.8, 1.0);
    materialSpecular = float4(0.0, 0.7, 0.9, 1.0);
    textureColor = float4(0.0, 0.8, 1.0, 1.0);

    float4 viewDirection = normalize(cameraPosition - input.worldPosition);
    float4 lightDirection = normalize(lightPosition - input.worldPosition);
    float4 reflection = normalize(reflect(-lightDirection, input.normal));

    diffuseFactor = saturate(dot(lightDirection, input.normal));

    if (diffuseFactor > 0)
    {
        specularFactor += pow(saturate(dot(viewDirection, reflection)), 0.1 * 128);
    }

    diffuseColor = lightColor * diffuseFactor;
    specularColor = lightColor * specularFactor;

    finalColor = saturate(ambientColor + (diffuseColor * materialDiffuse) + (specularColor * materialSpecular));

    return saturate(finalColor * textureColor);
}
