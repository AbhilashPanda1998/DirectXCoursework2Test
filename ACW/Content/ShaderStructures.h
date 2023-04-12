#pragma once

namespace ACW
{
	// Constant buffer used to send MVP matrices to the vertex shader.
	struct ModelViewProjectionConstantBuffer
	{
		DirectX::XMFLOAT4X4 fmodel;
		DirectX::XMFLOAT4X4 view;
		DirectX::XMFLOAT4X4 projection;
		DirectX::XMFLOAT4 eye;
		DirectX::XMFLOAT4 lookAt;
		DirectX::XMFLOAT4 upDir;
	};

	struct LightConstantBuffer
	{
		DirectX::XMFLOAT4 lightPos;
		DirectX::XMFLOAT4 lightColour;
	};

	struct TimeConstantBuffer
	{
		float time;
		DirectX::XMFLOAT3 padding;
	};

	// Used to send per-vertex data to the vertex shader.
	struct Vertex
	{
		DirectX::XMFLOAT3 pos;
	};

	// Used to send per-vertex data to the vertex shader.
	struct VertexPositionColor
	{
		DirectX::XMFLOAT3 pos;
		DirectX::XMFLOAT3 color;
	};

	struct VertexType
	{
		DirectX::XMFLOAT3 pos; 
		DirectX::XMFLOAT2 col;
	};

	struct VertexNorm
	{
		DirectX::XMFLOAT3 position;  // 3D position
		DirectX::XMFLOAT3 normal;    // Normal vector
		DirectX::XMFLOAT2 texCoord;  // Texture coordinates
	};
}