#pragma once

#include "..\Common\DeviceResources.h"
#include "ShaderStructures.h"
#include "..\Common\StepTimer.h"
#include <vector>
#include "DDSTextureLoader.h"

using namespace DirectX;

namespace ACW
{
	// This sample renderer instantiates a basic rendering pipeline.
	class Sample3DSceneRenderer
	{
	public:
		Sample3DSceneRenderer(const std::shared_ptr<DX::DeviceResources>& deviceResources);
		void CreateDeviceDependentResources();
		void CreateWindowSizeDependentResources();
		void ReleaseDeviceDependentResources();
		void Update(DX::StepTimer const& timer, const std::vector<bool>& pInput);
		void Render();

	private:
		void RenderBubbles();
		
		//Water and terrain done using vertex, pixel, hull, and domain shader

		void CreateTerrain();
		void RenderTerrain();

		void CreateWater();
		void RenderWater();

		//Sea Plants done using vertex, pixel and geometry shader

		void CreateSeaWeeds();
		void RenderSeaWeeds();

		//Different types of fish experient using vertex, pixel and geometry shader
		void CreateFishes();
		void RenderFishes();
		
		void CreateStarfish();
		void RenderStarfish();

		void CreateStarfish1();
		void RenderStarfish1();

		void CreateSpecialfish();
		void RenderSpecialfish();

		//For Creating Coral using Geometry Shader
		void CreateCoral();
		void RenderCoral();

		//For Creating Coral using Pixel Shader
		void CreateCorals1();
		void RenderCorals1();

		//For Creating Coral using Vertex Shader
		void CreateCorals2();
		void RenderCorals2();

		//For Creating Coral using Hull and Domain Shader
		void CreateCorals3();
		void RenderCorals3();
		
		void CreateBuffers();
		void SetBuffers();

		void UpdateBuffers();
		void CreateBlendStates();
		
		void CreateDepthStencils();
		void CreateRasteriserStates();
		
		void CreateSamplerState();

	private:
		//Cached pointer to device resources.
		std::shared_ptr<DX::DeviceResources> m_deviceResources;
		Microsoft::WRL::ComPtr<ID3D11DeviceContext3> mContext;

		//Input layout for vertex data
		Microsoft::WRL::ComPtr<ID3D11InputLayout>	m_inputLayout;

		//Cube vertices/indices
		Microsoft::WRL::ComPtr<ID3D11Buffer>		m_vertexBuffer;
		Microsoft::WRL::ComPtr<ID3D11Buffer>		m_indexBuffer;

		Microsoft::WRL::ComPtr<ID3D11Buffer> seaWeedsVertexBuffer;
		Microsoft::WRL::ComPtr<ID3D11Buffer> seaWeedsIndexBuffer;
		
		Microsoft::WRL::ComPtr<ID3D11Buffer> fishVertexBuffer;
		Microsoft::WRL::ComPtr<ID3D11Buffer> fishIndexBuffer;
		Microsoft::WRL::ComPtr<ID3D11Buffer> fish1VertexBuffer;
		Microsoft::WRL::ComPtr<ID3D11Buffer> fish1IndexBuffer;
		Microsoft::WRL::ComPtr<ID3D11Buffer> fish2VertexBuffer;
		Microsoft::WRL::ComPtr<ID3D11Buffer> fish2IndexBuffer;
		Microsoft::WRL::ComPtr<ID3D11Buffer> fish3VertexBuffer;
		Microsoft::WRL::ComPtr<ID3D11Buffer> fish3IndexBuffer;

		//Terrain shaders
		Microsoft::WRL::ComPtr<ID3D11VertexShader> mVertexShaderTerrain;
		Microsoft::WRL::ComPtr<ID3D11PixelShader> mPixelShaderTerrain;
		Microsoft::WRL::ComPtr<ID3D11HullShader> mHullShaderTerrain;
		Microsoft::WRL::ComPtr<ID3D11DomainShader> mDomainShaderTerrain;

		//Bubbles shaders
		Microsoft::WRL::ComPtr<ID3D11VertexShader> mVertexShaderBubbles;
		Microsoft::WRL::ComPtr<ID3D11PixelShader> mPixelShaderBubbles;

		Microsoft::WRL::ComPtr<ID3D11VertexShader> seaWeedsVertexShader;
		Microsoft::WRL::ComPtr<ID3D11PixelShader> seaWeedsPixelShader;
		Microsoft::WRL::ComPtr<ID3D11GeometryShader> seaWeedsGeometryShader;
 
		Microsoft::WRL::ComPtr<ID3D11VertexShader> fishVertexShader;
		Microsoft::WRL::ComPtr<ID3D11PixelShader> fishPixelShader;
		Microsoft::WRL::ComPtr<ID3D11GeometryShader> fishGeometryShader;
		Microsoft::WRL::ComPtr<ID3D11VertexShader> fish1VertexShader;
		Microsoft::WRL::ComPtr<ID3D11PixelShader> fish1PixelShader;
		Microsoft::WRL::ComPtr<ID3D11GeometryShader> fish1GeometryShader;
		Microsoft::WRL::ComPtr<ID3D11VertexShader> fish2VertexShader;
		Microsoft::WRL::ComPtr<ID3D11PixelShader> fish2PixelShader;
		Microsoft::WRL::ComPtr<ID3D11GeometryShader> fish2GeometryShader;
		Microsoft::WRL::ComPtr<ID3D11VertexShader> fish3VertexShader;
		Microsoft::WRL::ComPtr<ID3D11PixelShader> fish3PixelShader;
		Microsoft::WRL::ComPtr<ID3D11GeometryShader> fish3GeometryShader;

		//Water shaders
		Microsoft::WRL::ComPtr<ID3D11VertexShader> mVertexShaderWater;
		Microsoft::WRL::ComPtr<ID3D11PixelShader> mPixelShaderWater;
		Microsoft::WRL::ComPtr<ID3D11HullShader> mHullShaderWater;
		Microsoft::WRL::ComPtr<ID3D11DomainShader> mDomainShaderWater;

		//Coral shaders
		Microsoft::WRL::ComPtr<ID3D11Buffer> m_CoralVertexBuffer;
		Microsoft::WRL::ComPtr<ID3D11Buffer> m_CoralIndexBuffer;
		Microsoft::WRL::ComPtr<ID3D11VertexShader> m_CoralvertexShader;
		Microsoft::WRL::ComPtr<ID3D11PixelShader> m_CoralpixelShader;
		Microsoft::WRL::ComPtr<ID3D11GeometryShader> m_CoralGeometryShader;

		//Corals1 shaders
		Microsoft::WRL::ComPtr<ID3D11VertexShader> m_Corals1VertexShader;
		Microsoft::WRL::ComPtr<ID3D11PixelShader> m_Corals1PixelShader;


		//Coral2 shaders
		Microsoft::WRL::ComPtr<ID3D11Buffer> m_Coral2VertexBuffer;
		Microsoft::WRL::ComPtr<ID3D11Buffer> m_Coral2IndexBuffer;
		Microsoft::WRL::ComPtr<ID3D11VertexShader> m_Coral2vertexShader;
		Microsoft::WRL::ComPtr<ID3D11PixelShader> m_Coral2pixelShader;
		Microsoft::WRL::ComPtr<ID3D11GeometryShader> m_Coral2GeometryShader;

		//Coral3 shaders
		Microsoft::WRL::ComPtr<ID3D11Buffer> m_Coral3VertexBuffer;
		Microsoft::WRL::ComPtr<ID3D11Buffer> m_Coral3IndexBuffer;
		Microsoft::WRL::ComPtr<ID3D11VertexShader> m_Coral3vertexShader;
		Microsoft::WRL::ComPtr<ID3D11PixelShader> m_Coral3pixelShader;
		Microsoft::WRL::ComPtr<ID3D11HullShader> m_Coral3HullShader;
		Microsoft::WRL::ComPtr<ID3D11DomainShader> m_Coral3DomainShader;

		//Starfish shaders
		Microsoft::WRL::ComPtr<ID3D11Buffer> m_StarfishVertexBuffer;
		Microsoft::WRL::ComPtr<ID3D11Buffer> m_StarfishIndexBuffer;
		Microsoft::WRL::ComPtr<ID3D11VertexShader> m_StarfishVertexShader;
		Microsoft::WRL::ComPtr<ID3D11PixelShader> m_StarfishPixelShader;
		Microsoft::WRL::ComPtr<ID3D11GeometryShader> m_StarfishGeometryShader;

		//Starfish1 shaders
		Microsoft::WRL::ComPtr<ID3D11Buffer> m_Starfish1VertexBuffer;
		Microsoft::WRL::ComPtr<ID3D11Buffer> m_Starfish1IndexBuffer;
		Microsoft::WRL::ComPtr<ID3D11VertexShader> m_Starfish1VertexShader;
		Microsoft::WRL::ComPtr<ID3D11PixelShader> m_Starfish1PixelShader;
		Microsoft::WRL::ComPtr<ID3D11GeometryShader> m_Starfish1GeometryShader;

		//SpecialFish shaders
		Microsoft::WRL::ComPtr<ID3D11Buffer> m_SpecialFishVertexBuffer;
		Microsoft::WRL::ComPtr<ID3D11Buffer> m_SpecialFishIndexBuffer;
		Microsoft::WRL::ComPtr<ID3D11VertexShader> m_SpecialFishVertexShader;
		Microsoft::WRL::ComPtr<ID3D11PixelShader> m_SpecialFishPixelShader;
		Microsoft::WRL::ComPtr<ID3D11GeometryShader> m_SpecialFishGeometryShader;

		//Rasteriser states
		Microsoft::WRL::ComPtr<ID3D11RasterizerState> mDefaultRasteriser;
		Microsoft::WRL::ComPtr<ID3D11RasterizerState> mWireframeRasteriser;

		//Texture/Sampler
		Microsoft::WRL::ComPtr<ID3D11ShaderResourceView> seaWeedsTexture;
		Microsoft::WRL::ComPtr<ID3D11SamplerState> mSampler;

		//Blend states
		Microsoft::WRL::ComPtr<ID3D11BlendState> mAlphaBlend;
		Microsoft::WRL::ComPtr<ID3D11BlendState> mNoBlend;

		//Depth stencils
		Microsoft::WRL::ComPtr<ID3D11DepthStencilState> mDepthLessThanEqual;
		Microsoft::WRL::ComPtr<ID3D11DepthStencilState> mDepthLessThanEqualAll;

		//Constant buffers pointers
		Microsoft::WRL::ComPtr<ID3D11Buffer>		m_constantBufferCamera;
		Microsoft::WRL::ComPtr<ID3D11Buffer>		mConstantBufferLight;
		Microsoft::WRL::ComPtr<ID3D11Buffer>		mConstantBufferTime;

		//Constant buffers data
		ModelViewProjectionConstantBuffer	m_constantBufferDataCamera;
		LightConstantBuffer mConstantBufferDataLight;
		TimeConstantBuffer mConstantBufferDataTime;

		//Variables
		uint32	m_indexCount;
		uint32 seaWeedsIndex;
		uint32 fishIndex;
		bool	m_loadingComplete;
		XMVECTOR eye = { 0, 5, -10, 1 };
		XMVECTOR at = { 0.0f, 5.0f, 1.0f, 0.0f };
		XMVECTOR up = { 0.0f, 1.0f, 0.0f, 0.0f };
		XMMATRIX lookAt;
	};
}

