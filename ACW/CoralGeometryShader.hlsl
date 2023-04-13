cbuffer ModelViewProjectionConstantBuffer : register(b0)
{
    matrix model;
    matrix view;
    matrix projection;
};

struct GeometryShaderInput
{
    float4 pos : SV_POSITION;
    float3 color : COLOR0;
};

struct PixelShaderInput
{
    float4 pos : SV_POSITION;
    float3 color : COLOR0;
    float2 uv : TEXCOORD0;
};

cbuffer timeConstantBuffer : register(b1)
{
    float time;
    float3 padding;
}

// Define a function to generate a random float in the range [minValue, maxValue]
float randomFloat(float minValue, float maxValue)
{
    return minValue + (maxValue - minValue) * frac(sin(dot(float2(42.0, 17.0), float2(time, 0.0))) * 753.5453123);
}

// Define a function to generate a random point within a unit sphere
float3 randomSpherePoint(float radius)
{
    float theta = randomFloat(0.0, 2.0 * 3.14159265358979323846);
    float phi = acos(randomFloat(-1.0, 1.0));
    float3 point1 = float3(sin(phi) * cos(theta), sin(phi) * sin(theta), cos(phi)) * radius;
    return point1;
}

// Define a function to generate a random color
float3 randomColor()
{
    return float3(randomFloat(0.0, 1.0), randomFloat(0.0, 1.0), randomFloat(0.0, 1.0));
}

// Rodrigues' rotation formula to compute the rotated vector
float3 rotate(float3 v, float3 axis, float angle)
{
    float3 result;

    float cosAngle = cos(angle);
    float sinAngle = sin(angle);
    float oneMinusCosAngle = 1.0 - cosAngle;

    float3 crossAxisV = cross(axis, v);
    float3 axisNormalized = normalize(axis);

    result.x = (v.x * (cosAngle + axisNormalized.x * axisNormalized.x * oneMinusCosAngle)) +
               (v.y * (axisNormalized.x * axisNormalized.y * oneMinusCosAngle - axisNormalized.z * sinAngle)) +
               (v.z * (axisNormalized.x * axisNormalized.z * oneMinusCosAngle + axisNormalized.y * sinAngle));

    result.y = (v.x * (axisNormalized.y * axisNormalized.x * oneMinusCosAngle + axisNormalized.z * sinAngle)) +
               (v.y * (cosAngle + axisNormalized.y * axisNormalized.y * oneMinusCosAngle)) +
               (v.z * (axisNormalized.y * axisNormalized.z * oneMinusCosAngle - axisNormalized.x * sinAngle));

    result.z = (v.x * (axisNormalized.z * axisNormalized.x * oneMinusCosAngle - axisNormalized.y * sinAngle)) +
               (v.y * (axisNormalized.z * axisNormalized.y * oneMinusCosAngle + axisNormalized.x * sinAngle)) +
               (v.z * (cosAngle + axisNormalized.z * axisNormalized.z * oneMinusCosAngle));

    return result;
}

// Define the function to animate the petals
float4 animatePetals(float4 position, float time)
{
    // Define the animation parameters
    float amplitude = 0.1;
    float frequency = 2.0;
    float3 axis = float3(0.0, 0.0, 1.0);

    // Apply a rotation to the position based on time to make the petals sway back and forth
    float4 newPosition = position;
    newPosition.xyz = rotate(position.xyz, axis, sin(time * frequency + position.x) * amplitude);

    return newPosition;
}

// Define the output structure for the geometry shader
struct GSOutput
{
    float4 pos : SV_POSITION;
};

// Define the geometry shader
[maxvertexcount(9)]
void main(triangle GeometryShaderInput input[3], inout TriangleStream<PixelShaderInput> OutputStream)
{

    float3 scalingFactor = float3(2.0, 2.0, 2.0);

    float4x4 scaleMatrix = float4x4(
    scalingFactor.x, 0.0, 0.0, 0.0,
    0.0, scalingFactor.y, 0.0, 0.0,
    0.0, 0.0, scalingFactor.z, 0.0,
    0.0, 0.0, 0.0, 1.0
);
    
    // the flower petal shape by manipulating the input vertex position
    float4 pos1 = input[0].pos + float4(0.0, 0.0, 0.0, 0.0);
    float4 pos2 = input[0].pos + float4(0.1, 0.5, 0.0, 0.0);
    float4 pos3 = input[0].pos + float4(-0.1, 0.5, 0.0, 0.0);
    float4 pos4 = input[0].pos + float4(0.3, 0.3, 0.0, 0.0);
    float4 pos5 = input[0].pos + float4(-0.3, 0.3, 0.0, 0.0);
    
      // Apply animation to the petal vertices
    pos1 = animatePetals(pos1, time);
    pos2 = animatePetals(pos2, time);
    pos3 = animatePetals(pos3, time);
    pos4 = animatePetals(pos4, time);
    
    
    // Scaleing the vertices using the scaling matrix in the constant buffer
    pos1 = mul(pos1, scaleMatrix);
    pos2 = mul(pos2, scaleMatrix);
    pos3 = mul(pos3, scaleMatrix);
    pos4 = mul(pos4, scaleMatrix);
    pos5 = mul(pos5, scaleMatrix);
    
    // Transformimg the vertices using the model, view, and projection matrices
    pos1 = mul(pos1, model);
    pos1 = mul(pos1, view);
    pos1 = mul(pos1, projection);
    pos2 = mul(pos2, model);
    pos2 = mul(pos2, view);
    pos2 = mul(pos2, projection);
    pos3 = mul(pos3, model);
    pos3 = mul(pos3, view);
    pos3 = mul(pos3, projection);
    pos4 = mul(pos4, model);
    pos4 = mul(pos4, view);
    pos4 = mul(pos4, projection);
    pos5 = mul(pos5, model);
    pos5 = mul(pos5, view);
    pos5 = mul(pos5, projection);

    // Defining the pixel shader input vertices and their properties
    PixelShaderInput output = (PixelShaderInput) 0;
    output.pos = pos1;
    output.color = input[0].color;
    output.uv = float2(0.5, 0.5);
    OutputStream.Append(output);

    output.pos = pos2;
    output.color = input[0].color;
    output.uv = float2(1.0, 0.5);
    OutputStream.Append(output);

    output.pos = pos3;
    output.color = input[0].color;
    output.uv = float2(0.0, 0.5);
    OutputStream.Append(output);

    output.pos = pos4;
    output.color = input[0].color;
    output.uv = float2(0.5, 1.0);
    OutputStream.Append(output);

    output.pos = pos5;
    output.color = input[0].color;
    output.uv = float2(0.5, 0.0);
    OutputStream.Append(output);

    // Restart the triangle strip
    OutputStream.RestartStrip();
}
