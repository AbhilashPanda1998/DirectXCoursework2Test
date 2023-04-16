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

cbuffer Light : register(b1)
{
    float4 lightPos;
    float4 lightColour;
}

struct PixelShaderInput
{
    float4 position : SV_POSITION;
    float4 norm : NORMAL;
    float4 posWorld : TEXCOORD;
};

cbuffer timeConstantBuffer : register(b2)
{
    float time;
    float3 padding;
}


float4 main(PixelShaderInput input) : SV_TARGET
{
    // Calculate the direction from the light source to the current pixel
    float4 lightDir = normalize(lightPos - input.posWorld);

    // Calculate the diffuse lighting
    float diffuse = max(dot(input.norm, lightDir), 0);

    // Calculate the final color of the pixel using the diffuse lighting and light color
    float4 color = float4(lightColour.rgb * float3(0.8, 0.6, 0.2) * diffuse,  sin(time));

    // Apply the model, view, and projection matrices to the pixel position
    float4 worldPos = mul(input.posWorld, model);
    float4 viewPos = mul(worldPos, view);
    float4 projPos = mul(viewPos, projection);

    // Return the final color of the pixel with the lighting applied
    return color;
}