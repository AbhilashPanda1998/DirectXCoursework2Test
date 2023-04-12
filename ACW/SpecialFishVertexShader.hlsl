cbuffer ModelViewProjectionConstantBuffer : register(b0)
{
    matrix model;
    matrix view;
    matrix projection;
};

struct VertexShaderInput
{
    float3 pos : POSITION;
    float3 color : COLOR0;
};

struct PixelShaderInput
{
    float4 pos : SV_POSITION;
    float3 color : COLOR0;
};

cbuffer timeConstantBuffer : register(b1)
{
    float time;
    float3 padding;
}

PixelShaderInput main(VertexShaderInput input)
{
    float elapsed = 0;
    PixelShaderInput output;
    float3 inPos = input.pos;
    float4 pos = float4(inPos, 1.0f);

    pos = mul(pos, model);
    pos = mul(pos, view);
    pos = mul(pos, projection);

    output.pos = pos;
    output.color = input.color;
    elapsed += time;
    // Define a rotation axis and angle
    float3 axis = float3(1.0f, 1.0f, 1.0f); // Y-axis
    float angle =  radians(90); // 45 degrees in radians
    float4x4 rotationMatrix;
    // Create the rotation matrix
    rotationMatrix = float4x4(
        cos(angle) + axis.x * axis.x * (1.0f - cos(angle)), axis.x * axis.y * (1.0f - cos(angle)) - axis.z * sin(angle), axis.x * axis.z * (1.0f - cos(angle)) + axis.y * sin(angle), 0.0f,
        axis.y * axis.x * (1.0f - cos(angle)) + axis.z * sin(angle), cos(angle) + axis.y * axis.y * (1.0f - cos(angle)), axis.y * axis.z * (1.0f - cos(angle)) - axis.x * sin(angle), 0.0f,
        axis.z * axis.x * (1.0f - cos(angle)) - axis.y * sin(angle), axis.z * axis.y * (1.0f - cos(angle)) + axis.x * sin(angle), cos(angle) + axis.z * axis.z * (1.0f - cos(angle)), 0.0f,
        0.0f, 0.0f, 0.0f, 1.0f
    );

    // Transform the vertex position by the rotation matrix
    output.pos = mul(rotationMatrix, float4(input.pos, 1.0f));
    output.pos.xyz *= 0.015f;
    output.pos.x += 0.8f;
    output.pos.x -= time * 0.005f;
    return output;
}
