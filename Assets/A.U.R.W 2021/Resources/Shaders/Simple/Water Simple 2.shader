Shader "ABKaspo/A.U.R.W/Simple/Water Simple 2"
{
    Properties
    {
        _MainColor("Main Color", Color) = (0.3137255, 0.5215687, 0.6705883, 1)
        _DeepColor("Deep Color", Color) = (0.4745098, 1, 0.8078431, 1)
        [NoScaleOffset]_MainNormal("Main Normal", 2D) = "white" {}
        [NoScaleOffset]_SecondNormal("Second Normal", 2D) = "white" {}
        _NormalStrength("Normal Strength", Range(0, 1)) = 0.5
        _NormalTiling("Normal Tiling", Float) = 1
        _NormalSpeed("Normal Speed", Range(0, 100)) = 6
        _NormalDirection("Normal Direction", Vector) = (1, 0, 0, 0)
        _NormalDirection2("Normal Direction 2", Vector) = (-1, 0, 0, 0)
        _Smoothness("smoothness", Range(0, 1)) = 0.5
        _Transparent("Transparent", Range(0, 1)) = 0.7
        [NoScaleOffset]_DisplacementTexture("Displacement Texture", 2D) = "white" {}
        _Displacement("Displacement", Range(0, 50)) = 1
        _DisplacementSpeed("Displacement Speed", Range(0, 100)) = 100
        _DisplacemenTiling("Displacement Tiling", Range(0, 1000)) = 1
        _River("River", Float) = 1
        _RiverStrength("River Strengh", Float) = 1
        [NoScaleOffset]_WaveTexture("Wave Texture", 2D) = "white" {}
        _WaveSpeed("Wave Speed", Range(0, 1000)) = 0.08
        _WaveTiling("Wave Tiling", Float) = 1
        _WaveSrength("Wave Strength", Range(0, 15)) = 0.5
        _WaveDirection("Wave Direction", Vector) = (0, 1, 0, 0)
        _WaveDirection2("Wave Direction 2", Vector) = (0, 1, 0, 0)
    }
        SubShader
        {
            Tags
            {
                "RenderPipeline" = "UniversalPipeline"
                "RenderType" = "Transparent"
                "Queue" = "Transparent+0"
            }

            Pass
            {
                Name "Universal Forward"
                Tags
                {
                    "LightMode" = "UniversalForward"
                }

            // Render State
            Blend SrcAlpha OneMinusSrcAlpha, One OneMinusSrcAlpha
            Cull Back
            ZTest LEqual
            ZWrite Off
            // ColorMask: <None>


            HLSLPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            // Debug
            // <None>

            // --------------------------------------------------
            // Pass

            // Pragmas
            #pragma prefer_hlslcc gles
            #pragma exclude_renderers d3d11_9x
            #pragma target 2.0
            #pragma multi_compile_fog
            #pragma multi_compile_instancing

            // Keywords
            #pragma multi_compile _ LIGHTMAP_ON
            #pragma multi_compile _ DIRLIGHTMAP_COMBINED
            #pragma multi_compile _ _MAIN_LIGHT_SHADOWS
            #pragma multi_compile _ _MAIN_LIGHT_SHADOWS_CASCADE
            #pragma multi_compile _ADDITIONAL_LIGHTS_VERTEX _ADDITIONAL_LIGHTS _ADDITIONAL_OFF
            #pragma multi_compile _ _ADDITIONAL_LIGHT_SHADOWS
            #pragma multi_compile _ _SHADOWS_SOFT
            #pragma multi_compile _ _MIXED_LIGHTING_SUBTRACTIVE
            // GraphKeywords: <None>

            // Defines
            #define _SURFACE_TYPE_TRANSPARENT 1
            #define _AlphaClip 1
            #define _NORMALMAP 1
            #define _NORMAL_DROPOFF_OS 1
            #define ATTRIBUTES_NEED_NORMAL
            #define ATTRIBUTES_NEED_TANGENT
            #define ATTRIBUTES_NEED_TEXCOORD0
            #define ATTRIBUTES_NEED_TEXCOORD1
            #define VARYINGS_NEED_POSITION_WS 
            #define VARYINGS_NEED_NORMAL_WS
            #define VARYINGS_NEED_TANGENT_WS
            #define VARYINGS_NEED_VIEWDIRECTION_WS
            #define VARYINGS_NEED_FOG_AND_VERTEX_LIGHT
            #define FEATURES_GRAPH_VERTEX
            #pragma multi_compile_instancing
            #define SHADERPASS_FORWARD
            #define REQUIRE_DEPTH_TEXTURE


            // Includes
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Shadows.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
            #include "Packages/com.unity.shadergraph/ShaderGraphLibrary/ShaderVariablesFunctions.hlsl"

            // --------------------------------------------------
            // Graph

            // Graph Properties
            CBUFFER_START(UnityPerMaterial)
            float4 _MainColor;
            float4 _DeepColor;
            float _NormalStrength;
            float _NormalTiling;
            float _NormalSpeed;
            float2 _NormalDirection;
            float2 _NormalDirection2;
            float _Smoothness;
            float _Transparent;
            float _Displacement;
            float _DisplacementSpeed;
            float _DisplacemenTiling;
            float _River;
            float _RiverStrength;
            float _WaveSpeed;
            float _WaveTiling;
            float _WaveSrength;
            float3 _WaveDirection;
            float3 _WaveDirection2;
            CBUFFER_END
            TEXTURE2D(_MainNormal); SAMPLER(sampler_MainNormal); float4 _MainNormal_TexelSize;
            TEXTURE2D(_SecondNormal); SAMPLER(sampler_SecondNormal); float4 _SecondNormal_TexelSize;
            TEXTURE2D(_DisplacementTexture); SAMPLER(sampler_DisplacementTexture); float4 _DisplacementTexture_TexelSize;
            TEXTURE2D(_WaveTexture); SAMPLER(sampler_WaveTexture); float4 _WaveTexture_TexelSize;
            SAMPLER(_SampleTexture2DLOD_AA8AE8B8_Sampler_3_Linear_Repeat);
            SAMPLER(_SampleTexture2D_948BD954_Sampler_3_Linear_Repeat);
            SAMPLER(_SampleTexture2D_75C2D494_Sampler_3_Linear_Repeat);
            SAMPLER(_SampleTexture2D_EADA6B35_Sampler_3_Linear_Repeat);
            SAMPLER(_SampleTexture2D_E829F819_Sampler_3_Linear_Repeat);

            // Graph Functions

            void Unity_Divide_float(float A, float B, out float Out)
            {
                Out = A / B;
            }

            void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
            {
                Out = UV * Tiling + Offset;
            }

            void Unity_Multiply_float(float4 A, float4 B, out float4 Out)
            {
                Out = A * B;
            }

            void Unity_Combine_float(float R, float G, float B, float A, out float4 RGBA, out float3 RGB, out float2 RG)
            {
                RGBA = float4(R, G, B, A);
                RGB = float3(R, G, B);
                RG = float2(R, G);
            }

            void Unity_SceneDepth_Linear01_float(float4 UV, out float Out)
            {
                Out = Linear01Depth(SHADERGRAPH_SAMPLE_SCENE_DEPTH(UV.xy), _ZBufferParams);
            }

            void Unity_Multiply_float(float A, float B, out float Out)
            {
                Out = A * B;
            }

            void Unity_Add_float(float A, float B, out float Out)
            {
                Out = A + B;
            }

            void Unity_Subtract_float(float A, float B, out float Out)
            {
                Out = A - B;
            }

            void Unity_Clamp_float(float In, float Min, float Max, out float Out)
            {
                Out = clamp(In, Min, Max);
            }

            void Unity_Lerp_float4(float4 A, float4 B, float4 T, out float4 Out)
            {
                Out = lerp(A, B, T);
            }

            void Unity_Multiply_float(float2 A, float2 B, out float2 Out)
            {
                Out = A * B;
            }

            void Unity_Divide_float2(float2 A, float2 B, out float2 Out)
            {
                Out = A / B;
            }

            void Unity_Add_float4(float4 A, float4 B, out float4 Out)
            {
                Out = A + B;
            }

            void Unity_NormalStrength_float(float3 In, float Strength, out float3 Out)
            {
                Out = float3(In.rg * Strength, lerp(1, In.b, saturate(Strength)));
            }

            void Unity_Multiply_float(float3 A, float3 B, out float3 Out)
            {
                Out = A * B;
            }

            void Unity_Divide_float3(float3 A, float3 B, out float3 Out)
            {
                Out = A / B;
            }

            void Unity_NormalBlend_float(float3 A, float3 B, out float3 Out)
            {
                Out = SafeNormalize(float3(A.rg + B.rg, A.b * B.b));
            }

            // Graph Vertex
            struct VertexDescriptionInputs
            {
                float3 ObjectSpaceNormal;
                float3 ObjectSpaceTangent;
                float3 ObjectSpacePosition;
                float4 uv0;
                float3 TimeParameters;
            };

            struct VertexDescription
            {
                float3 VertexPosition;
                float3 VertexNormal;
                float3 VertexTangent;
            };

            VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
            {
                VertexDescription description = (VertexDescription)0;
                float _Split_70842E22_R_1 = IN.ObjectSpacePosition[0];
                float _Split_70842E22_G_2 = IN.ObjectSpacePosition[1];
                float _Split_70842E22_B_3 = IN.ObjectSpacePosition[2];
                float _Split_70842E22_A_4 = 0;
                float _Property_57764E91_Out_0 = _Displacement;
                float _Property_CB803CD5_Out_0 = _DisplacemenTiling;
                float _Property_4E7462E2_Out_0 = _DisplacementSpeed;
                float _Divide_166DB951_Out_2;
                Unity_Divide_float(IN.TimeParameters.x, _Property_4E7462E2_Out_0, _Divide_166DB951_Out_2);
                float2 _TilingAndOffset_7E2B06BA_Out_3;
                Unity_TilingAndOffset_float(IN.uv0.xy, (_Property_CB803CD5_Out_0.xx), (_Divide_166DB951_Out_2.xx), _TilingAndOffset_7E2B06BA_Out_3);
                float4 _SampleTexture2DLOD_AA8AE8B8_RGBA_0 = SAMPLE_TEXTURE2D_LOD(_DisplacementTexture, sampler_DisplacementTexture, _TilingAndOffset_7E2B06BA_Out_3, 0);
                float _SampleTexture2DLOD_AA8AE8B8_R_5 = _SampleTexture2DLOD_AA8AE8B8_RGBA_0.r;
                float _SampleTexture2DLOD_AA8AE8B8_G_6 = _SampleTexture2DLOD_AA8AE8B8_RGBA_0.g;
                float _SampleTexture2DLOD_AA8AE8B8_B_7 = _SampleTexture2DLOD_AA8AE8B8_RGBA_0.b;
                float _SampleTexture2DLOD_AA8AE8B8_A_8 = _SampleTexture2DLOD_AA8AE8B8_RGBA_0.a;
                float4 _Multiply_84EC1FCC_Out_2;
                Unity_Multiply_float((_Property_57764E91_Out_0.xxxx), _SampleTexture2DLOD_AA8AE8B8_RGBA_0, _Multiply_84EC1FCC_Out_2);
                float4 _Combine_15B33709_RGBA_4;
                float3 _Combine_15B33709_RGB_5;
                float2 _Combine_15B33709_RG_6;
                Unity_Combine_float(_Split_70842E22_R_1, (_Multiply_84EC1FCC_Out_2).x, _Split_70842E22_B_3, 0, _Combine_15B33709_RGBA_4, _Combine_15B33709_RGB_5, _Combine_15B33709_RG_6);
                description.VertexPosition = _Combine_15B33709_RGB_5;
                description.VertexNormal = IN.ObjectSpaceNormal;
                description.VertexTangent = IN.ObjectSpaceTangent;
                return description;
            }

            // Graph Pixel
            struct SurfaceDescriptionInputs
            {
                float3 WorldSpacePosition;
                float4 ScreenPosition;
                float3 TimeParameters;
            };

            struct SurfaceDescription
            {
                float3 Albedo;
                float3 Normal;
                float3 Emission;
                float Metallic;
                float Smoothness;
                float Occlusion;
                float Alpha;
                float AlphaClipThreshold;
            };

            SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
            {
                SurfaceDescription surface = (SurfaceDescription)0;
                float4 _Property_42D751D3_Out_0 = _DeepColor;
                float4 _Property_8E48FB3E_Out_0 = _MainColor;
                float _SceneDepth_CDF61EE_Out_1;
                Unity_SceneDepth_Linear01_float(float4(IN.ScreenPosition.xy / IN.ScreenPosition.w, 0, 0), _SceneDepth_CDF61EE_Out_1);
                float _Multiply_CB182ADB_Out_2;
                Unity_Multiply_float(_SceneDepth_CDF61EE_Out_1, _ProjectionParams.z, _Multiply_CB182ADB_Out_2);
                float4 _ScreenPosition_C5A924BF_Out_0 = IN.ScreenPosition;
                float _Split_C510B962_R_1 = _ScreenPosition_C5A924BF_Out_0[0];
                float _Split_C510B962_G_2 = _ScreenPosition_C5A924BF_Out_0[1];
                float _Split_C510B962_B_3 = _ScreenPosition_C5A924BF_Out_0[2];
                float _Split_C510B962_A_4 = _ScreenPosition_C5A924BF_Out_0[3];
                float _Property_B87591E4_Out_0 = _River;
                float _Add_A87090C3_Out_2;
                Unity_Add_float(_Split_C510B962_A_4, _Property_B87591E4_Out_0, _Add_A87090C3_Out_2);
                float _Subtract_AB9AA79F_Out_2;
                Unity_Subtract_float(_Multiply_CB182ADB_Out_2, _Add_A87090C3_Out_2, _Subtract_AB9AA79F_Out_2);
                float _Property_A9E53452_Out_0 = _RiverStrength;
                float _Multiply_C3C07A7C_Out_2;
                Unity_Multiply_float(_Subtract_AB9AA79F_Out_2, _Property_A9E53452_Out_0, _Multiply_C3C07A7C_Out_2);
                float _Clamp_11771326_Out_3;
                Unity_Clamp_float(_Multiply_C3C07A7C_Out_2, 0, 1, _Clamp_11771326_Out_3);
                float4 _Lerp_46069218_Out_3;
                Unity_Lerp_float4(_Property_42D751D3_Out_0, _Property_8E48FB3E_Out_0, (_Clamp_11771326_Out_3.xxxx), _Lerp_46069218_Out_3);
                float _Split_43AF283E_R_1 = IN.WorldSpacePosition[0];
                float _Split_43AF283E_G_2 = IN.WorldSpacePosition[1];
                float _Split_43AF283E_B_3 = IN.WorldSpacePosition[2];
                float _Split_43AF283E_A_4 = 0;
                float4 _Combine_9BC24C45_RGBA_4;
                float3 _Combine_9BC24C45_RGB_5;
                float2 _Combine_9BC24C45_RG_6;
                Unity_Combine_float(_Split_43AF283E_R_1, _Split_43AF283E_B_3, 0, 0, _Combine_9BC24C45_RGBA_4, _Combine_9BC24C45_RGB_5, _Combine_9BC24C45_RG_6);
                float2 _Property_8F595C56_Out_0 = _NormalDirection;
                float2 _Multiply_EB0AFE6E_Out_2;
                Unity_Multiply_float((IN.TimeParameters.x.xx), _Property_8F595C56_Out_0, _Multiply_EB0AFE6E_Out_2);
                float _Vector1_3A81E92C_Out_0 = 20;
                float2 _Divide_38247BB7_Out_2;
                Unity_Divide_float2(_Multiply_EB0AFE6E_Out_2, (_Vector1_3A81E92C_Out_0.xx), _Divide_38247BB7_Out_2);
                float _Property_1B5E121F_Out_0 = _NormalSpeed;
                float2 _Multiply_2008547C_Out_2;
                Unity_Multiply_float(_Divide_38247BB7_Out_2, (_Property_1B5E121F_Out_0.xx), _Multiply_2008547C_Out_2);
                float2 _TilingAndOffset_6AD8E7FF_Out_3;
                Unity_TilingAndOffset_float(_Combine_9BC24C45_RG_6, float2 (1, 1), _Multiply_2008547C_Out_2, _TilingAndOffset_6AD8E7FF_Out_3);
                float _Property_7C739135_Out_0 = _NormalTiling;
                float2 _Multiply_15197959_Out_2;
                Unity_Multiply_float(_TilingAndOffset_6AD8E7FF_Out_3, (_Property_7C739135_Out_0.xx), _Multiply_15197959_Out_2);
                float4 _SampleTexture2D_948BD954_RGBA_0 = SAMPLE_TEXTURE2D(_MainNormal, sampler_MainNormal, _Multiply_15197959_Out_2);
                _SampleTexture2D_948BD954_RGBA_0.rgb = UnpackNormal(_SampleTexture2D_948BD954_RGBA_0);
                float _SampleTexture2D_948BD954_R_4 = _SampleTexture2D_948BD954_RGBA_0.r;
                float _SampleTexture2D_948BD954_G_5 = _SampleTexture2D_948BD954_RGBA_0.g;
                float _SampleTexture2D_948BD954_B_6 = _SampleTexture2D_948BD954_RGBA_0.b;
                float _SampleTexture2D_948BD954_A_7 = _SampleTexture2D_948BD954_RGBA_0.a;
                float2 _Property_88045C24_Out_0 = _NormalDirection2;
                float2 _Multiply_A76FF61A_Out_2;
                Unity_Multiply_float((IN.TimeParameters.x.xx), _Property_88045C24_Out_0, _Multiply_A76FF61A_Out_2);
                float _Vector1_CB0A561E_Out_0 = 20;
                float2 _Divide_529C477F_Out_2;
                Unity_Divide_float2(_Multiply_A76FF61A_Out_2, (_Vector1_CB0A561E_Out_0.xx), _Divide_529C477F_Out_2);
                float2 _Multiply_28612446_Out_2;
                Unity_Multiply_float(_Divide_529C477F_Out_2, (_Property_1B5E121F_Out_0.xx), _Multiply_28612446_Out_2);
                float2 _TilingAndOffset_35CFFF77_Out_3;
                Unity_TilingAndOffset_float(_Combine_9BC24C45_RG_6, float2 (1, 1), _Multiply_28612446_Out_2, _TilingAndOffset_35CFFF77_Out_3);
                float2 _Multiply_77AE7733_Out_2;
                Unity_Multiply_float(_TilingAndOffset_35CFFF77_Out_3, (_Property_7C739135_Out_0.xx), _Multiply_77AE7733_Out_2);
                float4 _SampleTexture2D_75C2D494_RGBA_0 = SAMPLE_TEXTURE2D(_SecondNormal, sampler_SecondNormal, _Multiply_77AE7733_Out_2);
                _SampleTexture2D_75C2D494_RGBA_0.rgb = UnpackNormal(_SampleTexture2D_75C2D494_RGBA_0);
                float _SampleTexture2D_75C2D494_R_4 = _SampleTexture2D_75C2D494_RGBA_0.r;
                float _SampleTexture2D_75C2D494_G_5 = _SampleTexture2D_75C2D494_RGBA_0.g;
                float _SampleTexture2D_75C2D494_B_6 = _SampleTexture2D_75C2D494_RGBA_0.b;
                float _SampleTexture2D_75C2D494_A_7 = _SampleTexture2D_75C2D494_RGBA_0.a;
                float4 _Add_7A65BD9C_Out_2;
                Unity_Add_float4(_SampleTexture2D_948BD954_RGBA_0, _SampleTexture2D_75C2D494_RGBA_0, _Add_7A65BD9C_Out_2);
                float _Property_B2B4780A_Out_0 = _NormalStrength;
                float3 _NormalStrength_278CBAFF_Out_2;
                Unity_NormalStrength_float((_Add_7A65BD9C_Out_2.xyz), _Property_B2B4780A_Out_0, _NormalStrength_278CBAFF_Out_2);
                float3 _Property_DD7A4E62_Out_0 = _WaveDirection;
                float3 _Multiply_E95D9D62_Out_2;
                Unity_Multiply_float((IN.TimeParameters.x.xxx), _Property_DD7A4E62_Out_0, _Multiply_E95D9D62_Out_2);
                float _Vector1_1CCFF42F_Out_0 = 20;
                float3 _Divide_EE6E3F22_Out_2;
                Unity_Divide_float3(_Multiply_E95D9D62_Out_2, (_Vector1_1CCFF42F_Out_0.xxx), _Divide_EE6E3F22_Out_2);
                float _Property_E7952BF8_Out_0 = _WaveSpeed;
                float _Multiply_A3F51633_Out_2;
                Unity_Multiply_float(_Property_E7952BF8_Out_0, 100, _Multiply_A3F51633_Out_2);
                float3 _Multiply_DDDA21E6_Out_2;
                Unity_Multiply_float(_Divide_EE6E3F22_Out_2, (_Multiply_A3F51633_Out_2.xxx), _Multiply_DDDA21E6_Out_2);
                float2 _TilingAndOffset_AF41065E_Out_3;
                Unity_TilingAndOffset_float(_Combine_9BC24C45_RG_6, float2 (1, 1), (_Multiply_DDDA21E6_Out_2.xy), _TilingAndOffset_AF41065E_Out_3);
                float _Property_D39620CF_Out_0 = _WaveTiling;
                float2 _Multiply_79BAFC9E_Out_2;
                Unity_Multiply_float(_TilingAndOffset_AF41065E_Out_3, (_Property_D39620CF_Out_0.xx), _Multiply_79BAFC9E_Out_2);
                float4 _SampleTexture2D_EADA6B35_RGBA_0 = SAMPLE_TEXTURE2D(_WaveTexture, sampler_WaveTexture, _Multiply_79BAFC9E_Out_2);
                _SampleTexture2D_EADA6B35_RGBA_0.rgb = UnpackNormal(_SampleTexture2D_EADA6B35_RGBA_0);
                float _SampleTexture2D_EADA6B35_R_4 = _SampleTexture2D_EADA6B35_RGBA_0.r;
                float _SampleTexture2D_EADA6B35_G_5 = _SampleTexture2D_EADA6B35_RGBA_0.g;
                float _SampleTexture2D_EADA6B35_B_6 = _SampleTexture2D_EADA6B35_RGBA_0.b;
                float _SampleTexture2D_EADA6B35_A_7 = _SampleTexture2D_EADA6B35_RGBA_0.a;
                float3 _Property_E35E7C26_Out_0 = _WaveDirection2;
                float3 _Multiply_7068BBFB_Out_2;
                Unity_Multiply_float((IN.TimeParameters.x.xxx), _Property_E35E7C26_Out_0, _Multiply_7068BBFB_Out_2);
                float _Vector1_45645ABE_Out_0 = 20;
                float3 _Divide_465DB983_Out_2;
                Unity_Divide_float3(_Multiply_7068BBFB_Out_2, (_Vector1_45645ABE_Out_0.xxx), _Divide_465DB983_Out_2);
                float3 _Multiply_A5988270_Out_2;
                Unity_Multiply_float(_Divide_465DB983_Out_2, (_Multiply_A3F51633_Out_2.xxx), _Multiply_A5988270_Out_2);
                float2 _TilingAndOffset_686679E_Out_3;
                Unity_TilingAndOffset_float(_Combine_9BC24C45_RG_6, float2 (1, 1), (_Multiply_A5988270_Out_2.xy), _TilingAndOffset_686679E_Out_3);
                float2 _Multiply_A8AB70D7_Out_2;
                Unity_Multiply_float(_TilingAndOffset_686679E_Out_3, (_Property_D39620CF_Out_0.xx), _Multiply_A8AB70D7_Out_2);
                float4 _SampleTexture2D_E829F819_RGBA_0 = SAMPLE_TEXTURE2D(_WaveTexture, sampler_WaveTexture, _Multiply_A8AB70D7_Out_2);
                _SampleTexture2D_E829F819_RGBA_0.rgb = UnpackNormal(_SampleTexture2D_E829F819_RGBA_0);
                float _SampleTexture2D_E829F819_R_4 = _SampleTexture2D_E829F819_RGBA_0.r;
                float _SampleTexture2D_E829F819_G_5 = _SampleTexture2D_E829F819_RGBA_0.g;
                float _SampleTexture2D_E829F819_B_6 = _SampleTexture2D_E829F819_RGBA_0.b;
                float _SampleTexture2D_E829F819_A_7 = _SampleTexture2D_E829F819_RGBA_0.a;
                float4 _Add_9E92A9FC_Out_2;
                Unity_Add_float4(_SampleTexture2D_EADA6B35_RGBA_0, _SampleTexture2D_E829F819_RGBA_0, _Add_9E92A9FC_Out_2);
                float _Property_374E9555_Out_0 = _WaveSrength;
                float3 _NormalStrength_CE952267_Out_2;
                Unity_NormalStrength_float((_Add_9E92A9FC_Out_2.xyz), _Property_374E9555_Out_0, _NormalStrength_CE952267_Out_2);
                float3 _NormalBlend_226F1CD6_Out_2;
                Unity_NormalBlend_float(_NormalStrength_278CBAFF_Out_2, _NormalStrength_CE952267_Out_2, _NormalBlend_226F1CD6_Out_2);
                float _Property_168AC299_Out_0 = _Smoothness;
                float _Property_4860F22E_Out_0 = _Transparent;
                surface.Albedo = (_Lerp_46069218_Out_3.xyz);
                surface.Normal = _NormalBlend_226F1CD6_Out_2;
                surface.Emission = IsGammaSpace() ? float3(0, 0, 0) : SRGBToLinear(float3(0, 0, 0));
                surface.Metallic = 0;
                surface.Smoothness = _Property_168AC299_Out_0;
                surface.Occlusion = 1;
                surface.Alpha = _Property_4860F22E_Out_0;
                surface.AlphaClipThreshold = _Property_4860F22E_Out_0;
                return surface;
            }

            // --------------------------------------------------
            // Structs and Packing

            // Generated Type: Attributes
            struct Attributes
            {
                float3 positionOS : POSITION;
                float3 normalOS : NORMAL;
                float4 tangentOS : TANGENT;
                float4 uv0 : TEXCOORD0;
                float4 uv1 : TEXCOORD1;
                #if UNITY_ANY_INSTANCING_ENABLED
                uint instanceID : INSTANCEID_SEMANTIC;
                #endif
            };

            // Generated Type: Varyings
            struct Varyings
            {
                float4 positionCS : SV_POSITION;
                float3 positionWS;
                float3 normalWS;
                float4 tangentWS;
                float3 viewDirectionWS;
                #if defined(LIGHTMAP_ON)
                float2 lightmapUV;
                #endif
                #if !defined(LIGHTMAP_ON)
                float3 sh;
                #endif
                float4 fogFactorAndVertexLight;
                float4 shadowCoord;
                #if UNITY_ANY_INSTANCING_ENABLED
                uint instanceID : CUSTOM_INSTANCE_ID;
                #endif
                #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
                #endif
                #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
                #endif
                #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
                #endif
            };

            // Generated Type: PackedVaryings
            struct PackedVaryings
            {
                float4 positionCS : SV_POSITION;
                #if defined(LIGHTMAP_ON)
                #endif
                #if !defined(LIGHTMAP_ON)
                #endif
                #if UNITY_ANY_INSTANCING_ENABLED
                uint instanceID : CUSTOM_INSTANCE_ID;
                #endif
                float3 interp00 : TEXCOORD0;
                float3 interp01 : TEXCOORD1;
                float4 interp02 : TEXCOORD2;
                float3 interp03 : TEXCOORD3;
                float2 interp04 : TEXCOORD4;
                float3 interp05 : TEXCOORD5;
                float4 interp06 : TEXCOORD6;
                float4 interp07 : TEXCOORD7;
                #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
                #endif
                #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
                #endif
                #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
                #endif
            };

            // Packed Type: Varyings
            PackedVaryings PackVaryings(Varyings input)
            {
                PackedVaryings output = (PackedVaryings)0;
                output.positionCS = input.positionCS;
                output.interp00.xyz = input.positionWS;
                output.interp01.xyz = input.normalWS;
                output.interp02.xyzw = input.tangentWS;
                output.interp03.xyz = input.viewDirectionWS;
                #if defined(LIGHTMAP_ON)
                output.interp04.xy = input.lightmapUV;
                #endif
                #if !defined(LIGHTMAP_ON)
                output.interp05.xyz = input.sh;
                #endif
                output.interp06.xyzw = input.fogFactorAndVertexLight;
                output.interp07.xyzw = input.shadowCoord;
                #if UNITY_ANY_INSTANCING_ENABLED
                output.instanceID = input.instanceID;
                #endif
                #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
                #endif
                #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
                #endif
                #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                output.cullFace = input.cullFace;
                #endif
                return output;
            }

            // Unpacked Type: Varyings
            Varyings UnpackVaryings(PackedVaryings input)
            {
                Varyings output = (Varyings)0;
                output.positionCS = input.positionCS;
                output.positionWS = input.interp00.xyz;
                output.normalWS = input.interp01.xyz;
                output.tangentWS = input.interp02.xyzw;
                output.viewDirectionWS = input.interp03.xyz;
                #if defined(LIGHTMAP_ON)
                output.lightmapUV = input.interp04.xy;
                #endif
                #if !defined(LIGHTMAP_ON)
                output.sh = input.interp05.xyz;
                #endif
                output.fogFactorAndVertexLight = input.interp06.xyzw;
                output.shadowCoord = input.interp07.xyzw;
                #if UNITY_ANY_INSTANCING_ENABLED
                output.instanceID = input.instanceID;
                #endif
                #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
                #endif
                #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
                #endif
                #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                output.cullFace = input.cullFace;
                #endif
                return output;
            }

            // --------------------------------------------------
            // Build Graph Inputs

            VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
            {
                VertexDescriptionInputs output;
                ZERO_INITIALIZE(VertexDescriptionInputs, output);

                output.ObjectSpaceNormal = input.normalOS;
                output.ObjectSpaceTangent = input.tangentOS;
                output.ObjectSpacePosition = input.positionOS;
                output.uv0 = input.uv0;
                output.TimeParameters = _TimeParameters.xyz;

                return output;
            }

            SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
            {
                SurfaceDescriptionInputs output;
                ZERO_INITIALIZE(SurfaceDescriptionInputs, output);





                output.WorldSpacePosition = input.positionWS;
                output.ScreenPosition = ComputeScreenPos(TransformWorldToHClip(input.positionWS), _ProjectionParams.x);
                output.TimeParameters = _TimeParameters.xyz; // This is mainly for LW as HD overwrite this value
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
            #else
            #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
            #endif
            #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN

                return output;
            }


            // --------------------------------------------------
            // Main

            #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/PBRForwardPass.hlsl"

            ENDHLSL
        }

        Pass
        {
            Name "ShadowCaster"
            Tags
            {
                "LightMode" = "ShadowCaster"
            }

                // Render State
                Blend SrcAlpha OneMinusSrcAlpha, One OneMinusSrcAlpha
                Cull Back
                ZTest LEqual
                ZWrite On
                // ColorMask: <None>


                HLSLPROGRAM
                #pragma vertex vert
                #pragma fragment frag

                // Debug
                // <None>

                // --------------------------------------------------
                // Pass

                // Pragmas
                #pragma prefer_hlslcc gles
                #pragma exclude_renderers d3d11_9x
                #pragma target 2.0
                #pragma multi_compile_instancing

                // Keywords
                // PassKeywords: <None>
                // GraphKeywords: <None>

                // Defines
                #define _SURFACE_TYPE_TRANSPARENT 1
                #define _AlphaClip 1
                #define _NORMALMAP 1
                #define _NORMAL_DROPOFF_OS 1
                #define ATTRIBUTES_NEED_NORMAL
                #define ATTRIBUTES_NEED_TANGENT
                #define ATTRIBUTES_NEED_TEXCOORD0
                #define FEATURES_GRAPH_VERTEX
                #pragma multi_compile_instancing
                #define SHADERPASS_SHADOWCASTER


                // Includes
                #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
                #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
                #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
                #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
                #include "Packages/com.unity.shadergraph/ShaderGraphLibrary/ShaderVariablesFunctions.hlsl"

                // --------------------------------------------------
                // Graph

                // Graph Properties
                CBUFFER_START(UnityPerMaterial)
                float4 _MainColor;
                float4 _DeepColor;
                float _NormalStrength;
                float _NormalTiling;
                float _NormalSpeed;
                float2 _NormalDirection;
                float2 _NormalDirection2;
                float _Smoothness;
                float _Transparent;
                float _Displacement;
                float _DisplacementSpeed;
                float _DisplacemenTiling;
                float _River;
                float _RiverStrength;
                float _WaveSpeed;
                float _WaveTiling;
                float _WaveSrength;
                float3 _WaveDirection;
                float3 _WaveDirection2;
                CBUFFER_END
                TEXTURE2D(_MainNormal); SAMPLER(sampler_MainNormal); float4 _MainNormal_TexelSize;
                TEXTURE2D(_SecondNormal); SAMPLER(sampler_SecondNormal); float4 _SecondNormal_TexelSize;
                TEXTURE2D(_DisplacementTexture); SAMPLER(sampler_DisplacementTexture); float4 _DisplacementTexture_TexelSize;
                TEXTURE2D(_WaveTexture); SAMPLER(sampler_WaveTexture); float4 _WaveTexture_TexelSize;
                SAMPLER(_SampleTexture2DLOD_AA8AE8B8_Sampler_3_Linear_Repeat);

                // Graph Functions

                void Unity_Divide_float(float A, float B, out float Out)
                {
                    Out = A / B;
                }

                void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
                {
                    Out = UV * Tiling + Offset;
                }

                void Unity_Multiply_float(float4 A, float4 B, out float4 Out)
                {
                    Out = A * B;
                }

                void Unity_Combine_float(float R, float G, float B, float A, out float4 RGBA, out float3 RGB, out float2 RG)
                {
                    RGBA = float4(R, G, B, A);
                    RGB = float3(R, G, B);
                    RG = float2(R, G);
                }

                // Graph Vertex
                struct VertexDescriptionInputs
                {
                    float3 ObjectSpaceNormal;
                    float3 ObjectSpaceTangent;
                    float3 ObjectSpacePosition;
                    float4 uv0;
                    float3 TimeParameters;
                };

                struct VertexDescription
                {
                    float3 VertexPosition;
                    float3 VertexNormal;
                    float3 VertexTangent;
                };

                VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
                {
                    VertexDescription description = (VertexDescription)0;
                    float _Split_70842E22_R_1 = IN.ObjectSpacePosition[0];
                    float _Split_70842E22_G_2 = IN.ObjectSpacePosition[1];
                    float _Split_70842E22_B_3 = IN.ObjectSpacePosition[2];
                    float _Split_70842E22_A_4 = 0;
                    float _Property_57764E91_Out_0 = _Displacement;
                    float _Property_CB803CD5_Out_0 = _DisplacemenTiling;
                    float _Property_4E7462E2_Out_0 = _DisplacementSpeed;
                    float _Divide_166DB951_Out_2;
                    Unity_Divide_float(IN.TimeParameters.x, _Property_4E7462E2_Out_0, _Divide_166DB951_Out_2);
                    float2 _TilingAndOffset_7E2B06BA_Out_3;
                    Unity_TilingAndOffset_float(IN.uv0.xy, (_Property_CB803CD5_Out_0.xx), (_Divide_166DB951_Out_2.xx), _TilingAndOffset_7E2B06BA_Out_3);
                    float4 _SampleTexture2DLOD_AA8AE8B8_RGBA_0 = SAMPLE_TEXTURE2D_LOD(_DisplacementTexture, sampler_DisplacementTexture, _TilingAndOffset_7E2B06BA_Out_3, 0);
                    float _SampleTexture2DLOD_AA8AE8B8_R_5 = _SampleTexture2DLOD_AA8AE8B8_RGBA_0.r;
                    float _SampleTexture2DLOD_AA8AE8B8_G_6 = _SampleTexture2DLOD_AA8AE8B8_RGBA_0.g;
                    float _SampleTexture2DLOD_AA8AE8B8_B_7 = _SampleTexture2DLOD_AA8AE8B8_RGBA_0.b;
                    float _SampleTexture2DLOD_AA8AE8B8_A_8 = _SampleTexture2DLOD_AA8AE8B8_RGBA_0.a;
                    float4 _Multiply_84EC1FCC_Out_2;
                    Unity_Multiply_float((_Property_57764E91_Out_0.xxxx), _SampleTexture2DLOD_AA8AE8B8_RGBA_0, _Multiply_84EC1FCC_Out_2);
                    float4 _Combine_15B33709_RGBA_4;
                    float3 _Combine_15B33709_RGB_5;
                    float2 _Combine_15B33709_RG_6;
                    Unity_Combine_float(_Split_70842E22_R_1, (_Multiply_84EC1FCC_Out_2).x, _Split_70842E22_B_3, 0, _Combine_15B33709_RGBA_4, _Combine_15B33709_RGB_5, _Combine_15B33709_RG_6);
                    description.VertexPosition = _Combine_15B33709_RGB_5;
                    description.VertexNormal = IN.ObjectSpaceNormal;
                    description.VertexTangent = IN.ObjectSpaceTangent;
                    return description;
                }

                // Graph Pixel
                struct SurfaceDescriptionInputs
                {
                };

                struct SurfaceDescription
                {
                    float Alpha;
                    float AlphaClipThreshold;
                };

                SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
                {
                    SurfaceDescription surface = (SurfaceDescription)0;
                    float _Property_4860F22E_Out_0 = _Transparent;
                    surface.Alpha = _Property_4860F22E_Out_0;
                    surface.AlphaClipThreshold = _Property_4860F22E_Out_0;
                    return surface;
                }

                // --------------------------------------------------
                // Structs and Packing

                // Generated Type: Attributes
                struct Attributes
                {
                    float3 positionOS : POSITION;
                    float3 normalOS : NORMAL;
                    float4 tangentOS : TANGENT;
                    float4 uv0 : TEXCOORD0;
                    #if UNITY_ANY_INSTANCING_ENABLED
                    uint instanceID : INSTANCEID_SEMANTIC;
                    #endif
                };

                // Generated Type: Varyings
                struct Varyings
                {
                    float4 positionCS : SV_POSITION;
                    #if UNITY_ANY_INSTANCING_ENABLED
                    uint instanceID : CUSTOM_INSTANCE_ID;
                    #endif
                    #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                    uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
                    #endif
                    #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                    uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
                    #endif
                    #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                    FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
                    #endif
                };

                // Generated Type: PackedVaryings
                struct PackedVaryings
                {
                    float4 positionCS : SV_POSITION;
                    #if UNITY_ANY_INSTANCING_ENABLED
                    uint instanceID : CUSTOM_INSTANCE_ID;
                    #endif
                    #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                    uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
                    #endif
                    #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                    uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
                    #endif
                    #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                    FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
                    #endif
                };

                // Packed Type: Varyings
                PackedVaryings PackVaryings(Varyings input)
                {
                    PackedVaryings output = (PackedVaryings)0;
                    output.positionCS = input.positionCS;
                    #if UNITY_ANY_INSTANCING_ENABLED
                    output.instanceID = input.instanceID;
                    #endif
                    #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                    output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
                    #endif
                    #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                    output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
                    #endif
                    #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                    output.cullFace = input.cullFace;
                    #endif
                    return output;
                }

                // Unpacked Type: Varyings
                Varyings UnpackVaryings(PackedVaryings input)
                {
                    Varyings output = (Varyings)0;
                    output.positionCS = input.positionCS;
                    #if UNITY_ANY_INSTANCING_ENABLED
                    output.instanceID = input.instanceID;
                    #endif
                    #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                    output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
                    #endif
                    #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                    output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
                    #endif
                    #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                    output.cullFace = input.cullFace;
                    #endif
                    return output;
                }

                // --------------------------------------------------
                // Build Graph Inputs

                VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
                {
                    VertexDescriptionInputs output;
                    ZERO_INITIALIZE(VertexDescriptionInputs, output);

                    output.ObjectSpaceNormal = input.normalOS;
                    output.ObjectSpaceTangent = input.tangentOS;
                    output.ObjectSpacePosition = input.positionOS;
                    output.uv0 = input.uv0;
                    output.TimeParameters = _TimeParameters.xyz;

                    return output;
                }

                SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
                {
                    SurfaceDescriptionInputs output;
                    ZERO_INITIALIZE(SurfaceDescriptionInputs, output);





                #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
                #else
                #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
                #endif
                #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN

                    return output;
                }


                // --------------------------------------------------
                // Main

                #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
                #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShadowCasterPass.hlsl"

                ENDHLSL
            }

            Pass
            {
                Name "DepthOnly"
                Tags
                {
                    "LightMode" = "DepthOnly"
                }

                    // Render State
                    Blend SrcAlpha OneMinusSrcAlpha, One OneMinusSrcAlpha
                    Cull Back
                    ZTest LEqual
                    ZWrite On
                    ColorMask 0


                    HLSLPROGRAM
                    #pragma vertex vert
                    #pragma fragment frag

                    // Debug
                    // <None>

                    // --------------------------------------------------
                    // Pass

                    // Pragmas
                    #pragma prefer_hlslcc gles
                    #pragma exclude_renderers d3d11_9x
                    #pragma target 2.0
                    #pragma multi_compile_instancing

                    // Keywords
                    // PassKeywords: <None>
                    // GraphKeywords: <None>

                    // Defines
                    #define _SURFACE_TYPE_TRANSPARENT 1
                    #define _AlphaClip 1
                    #define _NORMALMAP 1
                    #define _NORMAL_DROPOFF_OS 1
                    #define ATTRIBUTES_NEED_NORMAL
                    #define ATTRIBUTES_NEED_TANGENT
                    #define ATTRIBUTES_NEED_TEXCOORD0
                    #define FEATURES_GRAPH_VERTEX
                    #pragma multi_compile_instancing
                    #define SHADERPASS_DEPTHONLY


                    // Includes
                    #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
                    #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
                    #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
                    #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
                    #include "Packages/com.unity.shadergraph/ShaderGraphLibrary/ShaderVariablesFunctions.hlsl"

                    // --------------------------------------------------
                    // Graph

                    // Graph Properties
                    CBUFFER_START(UnityPerMaterial)
                    float4 _MainColor;
                    float4 _DeepColor;
                    float _NormalStrength;
                    float _NormalTiling;
                    float _NormalSpeed;
                    float2 _NormalDirection;
                    float2 _NormalDirection2;
                    float _Smoothness;
                    float _Transparent;
                    float _Displacement;
                    float _DisplacementSpeed;
                    float _DisplacemenTiling;
                    float _River;
                    float _RiverStrength;
                    float _WaveSpeed;
                    float _WaveTiling;
                    float _WaveSrength;
                    float3 _WaveDirection;
                    float3 _WaveDirection2;
                    CBUFFER_END
                    TEXTURE2D(_MainNormal); SAMPLER(sampler_MainNormal); float4 _MainNormal_TexelSize;
                    TEXTURE2D(_SecondNormal); SAMPLER(sampler_SecondNormal); float4 _SecondNormal_TexelSize;
                    TEXTURE2D(_DisplacementTexture); SAMPLER(sampler_DisplacementTexture); float4 _DisplacementTexture_TexelSize;
                    TEXTURE2D(_WaveTexture); SAMPLER(sampler_WaveTexture); float4 _WaveTexture_TexelSize;
                    SAMPLER(_SampleTexture2DLOD_AA8AE8B8_Sampler_3_Linear_Repeat);

                    // Graph Functions

                    void Unity_Divide_float(float A, float B, out float Out)
                    {
                        Out = A / B;
                    }

                    void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
                    {
                        Out = UV * Tiling + Offset;
                    }

                    void Unity_Multiply_float(float4 A, float4 B, out float4 Out)
                    {
                        Out = A * B;
                    }

                    void Unity_Combine_float(float R, float G, float B, float A, out float4 RGBA, out float3 RGB, out float2 RG)
                    {
                        RGBA = float4(R, G, B, A);
                        RGB = float3(R, G, B);
                        RG = float2(R, G);
                    }

                    // Graph Vertex
                    struct VertexDescriptionInputs
                    {
                        float3 ObjectSpaceNormal;
                        float3 ObjectSpaceTangent;
                        float3 ObjectSpacePosition;
                        float4 uv0;
                        float3 TimeParameters;
                    };

                    struct VertexDescription
                    {
                        float3 VertexPosition;
                        float3 VertexNormal;
                        float3 VertexTangent;
                    };

                    VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
                    {
                        VertexDescription description = (VertexDescription)0;
                        float _Split_70842E22_R_1 = IN.ObjectSpacePosition[0];
                        float _Split_70842E22_G_2 = IN.ObjectSpacePosition[1];
                        float _Split_70842E22_B_3 = IN.ObjectSpacePosition[2];
                        float _Split_70842E22_A_4 = 0;
                        float _Property_57764E91_Out_0 = _Displacement;
                        float _Property_CB803CD5_Out_0 = _DisplacemenTiling;
                        float _Property_4E7462E2_Out_0 = _DisplacementSpeed;
                        float _Divide_166DB951_Out_2;
                        Unity_Divide_float(IN.TimeParameters.x, _Property_4E7462E2_Out_0, _Divide_166DB951_Out_2);
                        float2 _TilingAndOffset_7E2B06BA_Out_3;
                        Unity_TilingAndOffset_float(IN.uv0.xy, (_Property_CB803CD5_Out_0.xx), (_Divide_166DB951_Out_2.xx), _TilingAndOffset_7E2B06BA_Out_3);
                        float4 _SampleTexture2DLOD_AA8AE8B8_RGBA_0 = SAMPLE_TEXTURE2D_LOD(_DisplacementTexture, sampler_DisplacementTexture, _TilingAndOffset_7E2B06BA_Out_3, 0);
                        float _SampleTexture2DLOD_AA8AE8B8_R_5 = _SampleTexture2DLOD_AA8AE8B8_RGBA_0.r;
                        float _SampleTexture2DLOD_AA8AE8B8_G_6 = _SampleTexture2DLOD_AA8AE8B8_RGBA_0.g;
                        float _SampleTexture2DLOD_AA8AE8B8_B_7 = _SampleTexture2DLOD_AA8AE8B8_RGBA_0.b;
                        float _SampleTexture2DLOD_AA8AE8B8_A_8 = _SampleTexture2DLOD_AA8AE8B8_RGBA_0.a;
                        float4 _Multiply_84EC1FCC_Out_2;
                        Unity_Multiply_float((_Property_57764E91_Out_0.xxxx), _SampleTexture2DLOD_AA8AE8B8_RGBA_0, _Multiply_84EC1FCC_Out_2);
                        float4 _Combine_15B33709_RGBA_4;
                        float3 _Combine_15B33709_RGB_5;
                        float2 _Combine_15B33709_RG_6;
                        Unity_Combine_float(_Split_70842E22_R_1, (_Multiply_84EC1FCC_Out_2).x, _Split_70842E22_B_3, 0, _Combine_15B33709_RGBA_4, _Combine_15B33709_RGB_5, _Combine_15B33709_RG_6);
                        description.VertexPosition = _Combine_15B33709_RGB_5;
                        description.VertexNormal = IN.ObjectSpaceNormal;
                        description.VertexTangent = IN.ObjectSpaceTangent;
                        return description;
                    }

                    // Graph Pixel
                    struct SurfaceDescriptionInputs
                    {
                    };

                    struct SurfaceDescription
                    {
                        float Alpha;
                        float AlphaClipThreshold;
                    };

                    SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
                    {
                        SurfaceDescription surface = (SurfaceDescription)0;
                        float _Property_4860F22E_Out_0 = _Transparent;
                        surface.Alpha = _Property_4860F22E_Out_0;
                        surface.AlphaClipThreshold = _Property_4860F22E_Out_0;
                        return surface;
                    }

                    // --------------------------------------------------
                    // Structs and Packing

                    // Generated Type: Attributes
                    struct Attributes
                    {
                        float3 positionOS : POSITION;
                        float3 normalOS : NORMAL;
                        float4 tangentOS : TANGENT;
                        float4 uv0 : TEXCOORD0;
                        #if UNITY_ANY_INSTANCING_ENABLED
                        uint instanceID : INSTANCEID_SEMANTIC;
                        #endif
                    };

                    // Generated Type: Varyings
                    struct Varyings
                    {
                        float4 positionCS : SV_POSITION;
                        #if UNITY_ANY_INSTANCING_ENABLED
                        uint instanceID : CUSTOM_INSTANCE_ID;
                        #endif
                        #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                        uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
                        #endif
                        #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                        uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
                        #endif
                        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                        FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
                        #endif
                    };

                    // Generated Type: PackedVaryings
                    struct PackedVaryings
                    {
                        float4 positionCS : SV_POSITION;
                        #if UNITY_ANY_INSTANCING_ENABLED
                        uint instanceID : CUSTOM_INSTANCE_ID;
                        #endif
                        #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                        uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
                        #endif
                        #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                        uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
                        #endif
                        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                        FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
                        #endif
                    };

                    // Packed Type: Varyings
                    PackedVaryings PackVaryings(Varyings input)
                    {
                        PackedVaryings output = (PackedVaryings)0;
                        output.positionCS = input.positionCS;
                        #if UNITY_ANY_INSTANCING_ENABLED
                        output.instanceID = input.instanceID;
                        #endif
                        #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                        output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
                        #endif
                        #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                        output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
                        #endif
                        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                        output.cullFace = input.cullFace;
                        #endif
                        return output;
                    }

                    // Unpacked Type: Varyings
                    Varyings UnpackVaryings(PackedVaryings input)
                    {
                        Varyings output = (Varyings)0;
                        output.positionCS = input.positionCS;
                        #if UNITY_ANY_INSTANCING_ENABLED
                        output.instanceID = input.instanceID;
                        #endif
                        #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                        output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
                        #endif
                        #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                        output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
                        #endif
                        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                        output.cullFace = input.cullFace;
                        #endif
                        return output;
                    }

                    // --------------------------------------------------
                    // Build Graph Inputs

                    VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
                    {
                        VertexDescriptionInputs output;
                        ZERO_INITIALIZE(VertexDescriptionInputs, output);

                        output.ObjectSpaceNormal = input.normalOS;
                        output.ObjectSpaceTangent = input.tangentOS;
                        output.ObjectSpacePosition = input.positionOS;
                        output.uv0 = input.uv0;
                        output.TimeParameters = _TimeParameters.xyz;

                        return output;
                    }

                    SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
                    {
                        SurfaceDescriptionInputs output;
                        ZERO_INITIALIZE(SurfaceDescriptionInputs, output);





                    #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                    #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
                    #else
                    #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
                    #endif
                    #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN

                        return output;
                    }


                    // --------------------------------------------------
                    // Main

                    #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
                    #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/DepthOnlyPass.hlsl"

                    ENDHLSL
                }

                Pass
                {
                    Name "Meta"
                    Tags
                    {
                        "LightMode" = "Meta"
                    }

                        // Render State
                        Blend SrcAlpha OneMinusSrcAlpha, One OneMinusSrcAlpha
                        Cull Back
                        ZTest LEqual
                        ZWrite On
                        // ColorMask: <None>


                        HLSLPROGRAM
                        #pragma vertex vert
                        #pragma fragment frag

                        // Debug
                        // <None>

                        // --------------------------------------------------
                        // Pass

                        // Pragmas
                        #pragma prefer_hlslcc gles
                        #pragma exclude_renderers d3d11_9x
                        #pragma target 2.0

                        // Keywords
                        #pragma shader_feature _ _SMOOTHNESS_TEXTURE_ALBEDO_CHANNEL_A
                        // GraphKeywords: <None>

                        // Defines
                        #define _SURFACE_TYPE_TRANSPARENT 1
                        #define _AlphaClip 1
                        #define _NORMALMAP 1
                        #define _NORMAL_DROPOFF_OS 1
                        #define ATTRIBUTES_NEED_NORMAL
                        #define ATTRIBUTES_NEED_TANGENT
                        #define ATTRIBUTES_NEED_TEXCOORD0
                        #define ATTRIBUTES_NEED_TEXCOORD1
                        #define ATTRIBUTES_NEED_TEXCOORD2
                        #define VARYINGS_NEED_POSITION_WS 
                        #define FEATURES_GRAPH_VERTEX
                        #pragma multi_compile_instancing
                        #define SHADERPASS_META
                        #define REQUIRE_DEPTH_TEXTURE


                        // Includes
                        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
                        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
                        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
                        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
                        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/MetaInput.hlsl"
                        #include "Packages/com.unity.shadergraph/ShaderGraphLibrary/ShaderVariablesFunctions.hlsl"

                        // --------------------------------------------------
                        // Graph

                        // Graph Properties
                        CBUFFER_START(UnityPerMaterial)
                        float4 _MainColor;
                        float4 _DeepColor;
                        float _NormalStrength;
                        float _NormalTiling;
                        float _NormalSpeed;
                        float2 _NormalDirection;
                        float2 _NormalDirection2;
                        float _Smoothness;
                        float _Transparent;
                        float _Displacement;
                        float _DisplacementSpeed;
                        float _DisplacemenTiling;
                        float _River;
                        float _RiverStrength;
                        float _WaveSpeed;
                        float _WaveTiling;
                        float _WaveSrength;
                        float3 _WaveDirection;
                        float3 _WaveDirection2;
                        CBUFFER_END
                        TEXTURE2D(_MainNormal); SAMPLER(sampler_MainNormal); float4 _MainNormal_TexelSize;
                        TEXTURE2D(_SecondNormal); SAMPLER(sampler_SecondNormal); float4 _SecondNormal_TexelSize;
                        TEXTURE2D(_DisplacementTexture); SAMPLER(sampler_DisplacementTexture); float4 _DisplacementTexture_TexelSize;
                        TEXTURE2D(_WaveTexture); SAMPLER(sampler_WaveTexture); float4 _WaveTexture_TexelSize;
                        SAMPLER(_SampleTexture2DLOD_AA8AE8B8_Sampler_3_Linear_Repeat);

                        // Graph Functions

                        void Unity_Divide_float(float A, float B, out float Out)
                        {
                            Out = A / B;
                        }

                        void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
                        {
                            Out = UV * Tiling + Offset;
                        }

                        void Unity_Multiply_float(float4 A, float4 B, out float4 Out)
                        {
                            Out = A * B;
                        }

                        void Unity_Combine_float(float R, float G, float B, float A, out float4 RGBA, out float3 RGB, out float2 RG)
                        {
                            RGBA = float4(R, G, B, A);
                            RGB = float3(R, G, B);
                            RG = float2(R, G);
                        }

                        void Unity_SceneDepth_Linear01_float(float4 UV, out float Out)
                        {
                            Out = Linear01Depth(SHADERGRAPH_SAMPLE_SCENE_DEPTH(UV.xy), _ZBufferParams);
                        }

                        void Unity_Multiply_float(float A, float B, out float Out)
                        {
                            Out = A * B;
                        }

                        void Unity_Add_float(float A, float B, out float Out)
                        {
                            Out = A + B;
                        }

                        void Unity_Subtract_float(float A, float B, out float Out)
                        {
                            Out = A - B;
                        }

                        void Unity_Clamp_float(float In, float Min, float Max, out float Out)
                        {
                            Out = clamp(In, Min, Max);
                        }

                        void Unity_Lerp_float4(float4 A, float4 B, float4 T, out float4 Out)
                        {
                            Out = lerp(A, B, T);
                        }

                        // Graph Vertex
                        struct VertexDescriptionInputs
                        {
                            float3 ObjectSpaceNormal;
                            float3 ObjectSpaceTangent;
                            float3 ObjectSpacePosition;
                            float4 uv0;
                            float3 TimeParameters;
                        };

                        struct VertexDescription
                        {
                            float3 VertexPosition;
                            float3 VertexNormal;
                            float3 VertexTangent;
                        };

                        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
                        {
                            VertexDescription description = (VertexDescription)0;
                            float _Split_70842E22_R_1 = IN.ObjectSpacePosition[0];
                            float _Split_70842E22_G_2 = IN.ObjectSpacePosition[1];
                            float _Split_70842E22_B_3 = IN.ObjectSpacePosition[2];
                            float _Split_70842E22_A_4 = 0;
                            float _Property_57764E91_Out_0 = _Displacement;
                            float _Property_CB803CD5_Out_0 = _DisplacemenTiling;
                            float _Property_4E7462E2_Out_0 = _DisplacementSpeed;
                            float _Divide_166DB951_Out_2;
                            Unity_Divide_float(IN.TimeParameters.x, _Property_4E7462E2_Out_0, _Divide_166DB951_Out_2);
                            float2 _TilingAndOffset_7E2B06BA_Out_3;
                            Unity_TilingAndOffset_float(IN.uv0.xy, (_Property_CB803CD5_Out_0.xx), (_Divide_166DB951_Out_2.xx), _TilingAndOffset_7E2B06BA_Out_3);
                            float4 _SampleTexture2DLOD_AA8AE8B8_RGBA_0 = SAMPLE_TEXTURE2D_LOD(_DisplacementTexture, sampler_DisplacementTexture, _TilingAndOffset_7E2B06BA_Out_3, 0);
                            float _SampleTexture2DLOD_AA8AE8B8_R_5 = _SampleTexture2DLOD_AA8AE8B8_RGBA_0.r;
                            float _SampleTexture2DLOD_AA8AE8B8_G_6 = _SampleTexture2DLOD_AA8AE8B8_RGBA_0.g;
                            float _SampleTexture2DLOD_AA8AE8B8_B_7 = _SampleTexture2DLOD_AA8AE8B8_RGBA_0.b;
                            float _SampleTexture2DLOD_AA8AE8B8_A_8 = _SampleTexture2DLOD_AA8AE8B8_RGBA_0.a;
                            float4 _Multiply_84EC1FCC_Out_2;
                            Unity_Multiply_float((_Property_57764E91_Out_0.xxxx), _SampleTexture2DLOD_AA8AE8B8_RGBA_0, _Multiply_84EC1FCC_Out_2);
                            float4 _Combine_15B33709_RGBA_4;
                            float3 _Combine_15B33709_RGB_5;
                            float2 _Combine_15B33709_RG_6;
                            Unity_Combine_float(_Split_70842E22_R_1, (_Multiply_84EC1FCC_Out_2).x, _Split_70842E22_B_3, 0, _Combine_15B33709_RGBA_4, _Combine_15B33709_RGB_5, _Combine_15B33709_RG_6);
                            description.VertexPosition = _Combine_15B33709_RGB_5;
                            description.VertexNormal = IN.ObjectSpaceNormal;
                            description.VertexTangent = IN.ObjectSpaceTangent;
                            return description;
                        }

                        // Graph Pixel
                        struct SurfaceDescriptionInputs
                        {
                            float3 WorldSpacePosition;
                            float4 ScreenPosition;
                        };

                        struct SurfaceDescription
                        {
                            float3 Albedo;
                            float3 Emission;
                            float Alpha;
                            float AlphaClipThreshold;
                        };

                        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
                        {
                            SurfaceDescription surface = (SurfaceDescription)0;
                            float4 _Property_42D751D3_Out_0 = _DeepColor;
                            float4 _Property_8E48FB3E_Out_0 = _MainColor;
                            float _SceneDepth_CDF61EE_Out_1;
                            Unity_SceneDepth_Linear01_float(float4(IN.ScreenPosition.xy / IN.ScreenPosition.w, 0, 0), _SceneDepth_CDF61EE_Out_1);
                            float _Multiply_CB182ADB_Out_2;
                            Unity_Multiply_float(_SceneDepth_CDF61EE_Out_1, _ProjectionParams.z, _Multiply_CB182ADB_Out_2);
                            float4 _ScreenPosition_C5A924BF_Out_0 = IN.ScreenPosition;
                            float _Split_C510B962_R_1 = _ScreenPosition_C5A924BF_Out_0[0];
                            float _Split_C510B962_G_2 = _ScreenPosition_C5A924BF_Out_0[1];
                            float _Split_C510B962_B_3 = _ScreenPosition_C5A924BF_Out_0[2];
                            float _Split_C510B962_A_4 = _ScreenPosition_C5A924BF_Out_0[3];
                            float _Property_B87591E4_Out_0 = _River;
                            float _Add_A87090C3_Out_2;
                            Unity_Add_float(_Split_C510B962_A_4, _Property_B87591E4_Out_0, _Add_A87090C3_Out_2);
                            float _Subtract_AB9AA79F_Out_2;
                            Unity_Subtract_float(_Multiply_CB182ADB_Out_2, _Add_A87090C3_Out_2, _Subtract_AB9AA79F_Out_2);
                            float _Property_A9E53452_Out_0 = _RiverStrength;
                            float _Multiply_C3C07A7C_Out_2;
                            Unity_Multiply_float(_Subtract_AB9AA79F_Out_2, _Property_A9E53452_Out_0, _Multiply_C3C07A7C_Out_2);
                            float _Clamp_11771326_Out_3;
                            Unity_Clamp_float(_Multiply_C3C07A7C_Out_2, 0, 1, _Clamp_11771326_Out_3);
                            float4 _Lerp_46069218_Out_3;
                            Unity_Lerp_float4(_Property_42D751D3_Out_0, _Property_8E48FB3E_Out_0, (_Clamp_11771326_Out_3.xxxx), _Lerp_46069218_Out_3);
                            float _Property_4860F22E_Out_0 = _Transparent;
                            surface.Albedo = (_Lerp_46069218_Out_3.xyz);
                            surface.Emission = IsGammaSpace() ? float3(0, 0, 0) : SRGBToLinear(float3(0, 0, 0));
                            surface.Alpha = _Property_4860F22E_Out_0;
                            surface.AlphaClipThreshold = _Property_4860F22E_Out_0;
                            return surface;
                        }

                        // --------------------------------------------------
                        // Structs and Packing

                        // Generated Type: Attributes
                        struct Attributes
                        {
                            float3 positionOS : POSITION;
                            float3 normalOS : NORMAL;
                            float4 tangentOS : TANGENT;
                            float4 uv0 : TEXCOORD0;
                            float4 uv1 : TEXCOORD1;
                            float4 uv2 : TEXCOORD2;
                            #if UNITY_ANY_INSTANCING_ENABLED
                            uint instanceID : INSTANCEID_SEMANTIC;
                            #endif
                        };

                        // Generated Type: Varyings
                        struct Varyings
                        {
                            float4 positionCS : SV_POSITION;
                            float3 positionWS;
                            #if UNITY_ANY_INSTANCING_ENABLED
                            uint instanceID : CUSTOM_INSTANCE_ID;
                            #endif
                            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                            uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
                            #endif
                            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                            uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
                            #endif
                            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                            FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
                            #endif
                        };

                        // Generated Type: PackedVaryings
                        struct PackedVaryings
                        {
                            float4 positionCS : SV_POSITION;
                            #if UNITY_ANY_INSTANCING_ENABLED
                            uint instanceID : CUSTOM_INSTANCE_ID;
                            #endif
                            float3 interp00 : TEXCOORD0;
                            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                            uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
                            #endif
                            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                            uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
                            #endif
                            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                            FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
                            #endif
                        };

                        // Packed Type: Varyings
                        PackedVaryings PackVaryings(Varyings input)
                        {
                            PackedVaryings output = (PackedVaryings)0;
                            output.positionCS = input.positionCS;
                            output.interp00.xyz = input.positionWS;
                            #if UNITY_ANY_INSTANCING_ENABLED
                            output.instanceID = input.instanceID;
                            #endif
                            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
                            #endif
                            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
                            #endif
                            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                            output.cullFace = input.cullFace;
                            #endif
                            return output;
                        }

                        // Unpacked Type: Varyings
                        Varyings UnpackVaryings(PackedVaryings input)
                        {
                            Varyings output = (Varyings)0;
                            output.positionCS = input.positionCS;
                            output.positionWS = input.interp00.xyz;
                            #if UNITY_ANY_INSTANCING_ENABLED
                            output.instanceID = input.instanceID;
                            #endif
                            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
                            #endif
                            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
                            #endif
                            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                            output.cullFace = input.cullFace;
                            #endif
                            return output;
                        }

                        // --------------------------------------------------
                        // Build Graph Inputs

                        VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
                        {
                            VertexDescriptionInputs output;
                            ZERO_INITIALIZE(VertexDescriptionInputs, output);

                            output.ObjectSpaceNormal = input.normalOS;
                            output.ObjectSpaceTangent = input.tangentOS;
                            output.ObjectSpacePosition = input.positionOS;
                            output.uv0 = input.uv0;
                            output.TimeParameters = _TimeParameters.xyz;

                            return output;
                        }

                        SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
                        {
                            SurfaceDescriptionInputs output;
                            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);





                            output.WorldSpacePosition = input.positionWS;
                            output.ScreenPosition = ComputeScreenPos(TransformWorldToHClip(input.positionWS), _ProjectionParams.x);
                        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
                        #else
                        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
                        #endif
                        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN

                            return output;
                        }


                        // --------------------------------------------------
                        // Main

                        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
                        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/LightingMetaPass.hlsl"

                        ENDHLSL
                    }

                    Pass
                    {
                            // Name: <None>
                            Tags
                            {
                                "LightMode" = "Universal2D"
                            }

                            // Render State
                            Blend SrcAlpha OneMinusSrcAlpha, One OneMinusSrcAlpha
                            Cull Back
                            ZTest LEqual
                            ZWrite Off
                            // ColorMask: <None>


                            HLSLPROGRAM
                            #pragma vertex vert
                            #pragma fragment frag

                            // Debug
                            // <None>

                            // --------------------------------------------------
                            // Pass

                            // Pragmas
                            #pragma prefer_hlslcc gles
                            #pragma exclude_renderers d3d11_9x
                            #pragma target 2.0
                            #pragma multi_compile_instancing

                            // Keywords
                            // PassKeywords: <None>
                            // GraphKeywords: <None>

                            // Defines
                            #define _SURFACE_TYPE_TRANSPARENT 1
                            #define _AlphaClip 1
                            #define _NORMALMAP 1
                            #define _NORMAL_DROPOFF_OS 1
                            #define ATTRIBUTES_NEED_NORMAL
                            #define ATTRIBUTES_NEED_TANGENT
                            #define ATTRIBUTES_NEED_TEXCOORD0
                            #define VARYINGS_NEED_POSITION_WS 
                            #define FEATURES_GRAPH_VERTEX
                            #pragma multi_compile_instancing
                            #define SHADERPASS_2D
                            #define REQUIRE_DEPTH_TEXTURE


                            // Includes
                            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
                            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
                            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
                            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
                            #include "Packages/com.unity.shadergraph/ShaderGraphLibrary/ShaderVariablesFunctions.hlsl"

                            // --------------------------------------------------
                            // Graph

                            // Graph Properties
                            CBUFFER_START(UnityPerMaterial)
                            float4 _MainColor;
                            float4 _DeepColor;
                            float _NormalStrength;
                            float _NormalTiling;
                            float _NormalSpeed;
                            float2 _NormalDirection;
                            float2 _NormalDirection2;
                            float _Smoothness;
                            float _Transparent;
                            float _Displacement;
                            float _DisplacementSpeed;
                            float _DisplacemenTiling;
                            float _River;
                            float _RiverStrength;
                            float _WaveSpeed;
                            float _WaveTiling;
                            float _WaveSrength;
                            float3 _WaveDirection;
                            float3 _WaveDirection2;
                            CBUFFER_END
                            TEXTURE2D(_MainNormal); SAMPLER(sampler_MainNormal); float4 _MainNormal_TexelSize;
                            TEXTURE2D(_SecondNormal); SAMPLER(sampler_SecondNormal); float4 _SecondNormal_TexelSize;
                            TEXTURE2D(_DisplacementTexture); SAMPLER(sampler_DisplacementTexture); float4 _DisplacementTexture_TexelSize;
                            TEXTURE2D(_WaveTexture); SAMPLER(sampler_WaveTexture); float4 _WaveTexture_TexelSize;
                            SAMPLER(_SampleTexture2DLOD_AA8AE8B8_Sampler_3_Linear_Repeat);

                            // Graph Functions

                            void Unity_Divide_float(float A, float B, out float Out)
                            {
                                Out = A / B;
                            }

                            void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
                            {
                                Out = UV * Tiling + Offset;
                            }

                            void Unity_Multiply_float(float4 A, float4 B, out float4 Out)
                            {
                                Out = A * B;
                            }

                            void Unity_Combine_float(float R, float G, float B, float A, out float4 RGBA, out float3 RGB, out float2 RG)
                            {
                                RGBA = float4(R, G, B, A);
                                RGB = float3(R, G, B);
                                RG = float2(R, G);
                            }

                            void Unity_SceneDepth_Linear01_float(float4 UV, out float Out)
                            {
                                Out = Linear01Depth(SHADERGRAPH_SAMPLE_SCENE_DEPTH(UV.xy), _ZBufferParams);
                            }

                            void Unity_Multiply_float(float A, float B, out float Out)
                            {
                                Out = A * B;
                            }

                            void Unity_Add_float(float A, float B, out float Out)
                            {
                                Out = A + B;
                            }

                            void Unity_Subtract_float(float A, float B, out float Out)
                            {
                                Out = A - B;
                            }

                            void Unity_Clamp_float(float In, float Min, float Max, out float Out)
                            {
                                Out = clamp(In, Min, Max);
                            }

                            void Unity_Lerp_float4(float4 A, float4 B, float4 T, out float4 Out)
                            {
                                Out = lerp(A, B, T);
                            }

                            // Graph Vertex
                            struct VertexDescriptionInputs
                            {
                                float3 ObjectSpaceNormal;
                                float3 ObjectSpaceTangent;
                                float3 ObjectSpacePosition;
                                float4 uv0;
                                float3 TimeParameters;
                            };

                            struct VertexDescription
                            {
                                float3 VertexPosition;
                                float3 VertexNormal;
                                float3 VertexTangent;
                            };

                            VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
                            {
                                VertexDescription description = (VertexDescription)0;
                                float _Split_70842E22_R_1 = IN.ObjectSpacePosition[0];
                                float _Split_70842E22_G_2 = IN.ObjectSpacePosition[1];
                                float _Split_70842E22_B_3 = IN.ObjectSpacePosition[2];
                                float _Split_70842E22_A_4 = 0;
                                float _Property_57764E91_Out_0 = _Displacement;
                                float _Property_CB803CD5_Out_0 = _DisplacemenTiling;
                                float _Property_4E7462E2_Out_0 = _DisplacementSpeed;
                                float _Divide_166DB951_Out_2;
                                Unity_Divide_float(IN.TimeParameters.x, _Property_4E7462E2_Out_0, _Divide_166DB951_Out_2);
                                float2 _TilingAndOffset_7E2B06BA_Out_3;
                                Unity_TilingAndOffset_float(IN.uv0.xy, (_Property_CB803CD5_Out_0.xx), (_Divide_166DB951_Out_2.xx), _TilingAndOffset_7E2B06BA_Out_3);
                                float4 _SampleTexture2DLOD_AA8AE8B8_RGBA_0 = SAMPLE_TEXTURE2D_LOD(_DisplacementTexture, sampler_DisplacementTexture, _TilingAndOffset_7E2B06BA_Out_3, 0);
                                float _SampleTexture2DLOD_AA8AE8B8_R_5 = _SampleTexture2DLOD_AA8AE8B8_RGBA_0.r;
                                float _SampleTexture2DLOD_AA8AE8B8_G_6 = _SampleTexture2DLOD_AA8AE8B8_RGBA_0.g;
                                float _SampleTexture2DLOD_AA8AE8B8_B_7 = _SampleTexture2DLOD_AA8AE8B8_RGBA_0.b;
                                float _SampleTexture2DLOD_AA8AE8B8_A_8 = _SampleTexture2DLOD_AA8AE8B8_RGBA_0.a;
                                float4 _Multiply_84EC1FCC_Out_2;
                                Unity_Multiply_float((_Property_57764E91_Out_0.xxxx), _SampleTexture2DLOD_AA8AE8B8_RGBA_0, _Multiply_84EC1FCC_Out_2);
                                float4 _Combine_15B33709_RGBA_4;
                                float3 _Combine_15B33709_RGB_5;
                                float2 _Combine_15B33709_RG_6;
                                Unity_Combine_float(_Split_70842E22_R_1, (_Multiply_84EC1FCC_Out_2).x, _Split_70842E22_B_3, 0, _Combine_15B33709_RGBA_4, _Combine_15B33709_RGB_5, _Combine_15B33709_RG_6);
                                description.VertexPosition = _Combine_15B33709_RGB_5;
                                description.VertexNormal = IN.ObjectSpaceNormal;
                                description.VertexTangent = IN.ObjectSpaceTangent;
                                return description;
                            }

                            // Graph Pixel
                            struct SurfaceDescriptionInputs
                            {
                                float3 WorldSpacePosition;
                                float4 ScreenPosition;
                            };

                            struct SurfaceDescription
                            {
                                float3 Albedo;
                                float Alpha;
                                float AlphaClipThreshold;
                            };

                            SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
                            {
                                SurfaceDescription surface = (SurfaceDescription)0;
                                float4 _Property_42D751D3_Out_0 = _DeepColor;
                                float4 _Property_8E48FB3E_Out_0 = _MainColor;
                                float _SceneDepth_CDF61EE_Out_1;
                                Unity_SceneDepth_Linear01_float(float4(IN.ScreenPosition.xy / IN.ScreenPosition.w, 0, 0), _SceneDepth_CDF61EE_Out_1);
                                float _Multiply_CB182ADB_Out_2;
                                Unity_Multiply_float(_SceneDepth_CDF61EE_Out_1, _ProjectionParams.z, _Multiply_CB182ADB_Out_2);
                                float4 _ScreenPosition_C5A924BF_Out_0 = IN.ScreenPosition;
                                float _Split_C510B962_R_1 = _ScreenPosition_C5A924BF_Out_0[0];
                                float _Split_C510B962_G_2 = _ScreenPosition_C5A924BF_Out_0[1];
                                float _Split_C510B962_B_3 = _ScreenPosition_C5A924BF_Out_0[2];
                                float _Split_C510B962_A_4 = _ScreenPosition_C5A924BF_Out_0[3];
                                float _Property_B87591E4_Out_0 = _River;
                                float _Add_A87090C3_Out_2;
                                Unity_Add_float(_Split_C510B962_A_4, _Property_B87591E4_Out_0, _Add_A87090C3_Out_2);
                                float _Subtract_AB9AA79F_Out_2;
                                Unity_Subtract_float(_Multiply_CB182ADB_Out_2, _Add_A87090C3_Out_2, _Subtract_AB9AA79F_Out_2);
                                float _Property_A9E53452_Out_0 = _RiverStrength;
                                float _Multiply_C3C07A7C_Out_2;
                                Unity_Multiply_float(_Subtract_AB9AA79F_Out_2, _Property_A9E53452_Out_0, _Multiply_C3C07A7C_Out_2);
                                float _Clamp_11771326_Out_3;
                                Unity_Clamp_float(_Multiply_C3C07A7C_Out_2, 0, 1, _Clamp_11771326_Out_3);
                                float4 _Lerp_46069218_Out_3;
                                Unity_Lerp_float4(_Property_42D751D3_Out_0, _Property_8E48FB3E_Out_0, (_Clamp_11771326_Out_3.xxxx), _Lerp_46069218_Out_3);
                                float _Property_4860F22E_Out_0 = _Transparent;
                                surface.Albedo = (_Lerp_46069218_Out_3.xyz);
                                surface.Alpha = _Property_4860F22E_Out_0;
                                surface.AlphaClipThreshold = _Property_4860F22E_Out_0;
                                return surface;
                            }

                            // --------------------------------------------------
                            // Structs and Packing

                            // Generated Type: Attributes
                            struct Attributes
                            {
                                float3 positionOS : POSITION;
                                float3 normalOS : NORMAL;
                                float4 tangentOS : TANGENT;
                                float4 uv0 : TEXCOORD0;
                                #if UNITY_ANY_INSTANCING_ENABLED
                                uint instanceID : INSTANCEID_SEMANTIC;
                                #endif
                            };

                            // Generated Type: Varyings
                            struct Varyings
                            {
                                float4 positionCS : SV_POSITION;
                                float3 positionWS;
                                #if UNITY_ANY_INSTANCING_ENABLED
                                uint instanceID : CUSTOM_INSTANCE_ID;
                                #endif
                                #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                                uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
                                #endif
                                #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                                uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
                                #endif
                                #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                                FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
                                #endif
                            };

                            // Generated Type: PackedVaryings
                            struct PackedVaryings
                            {
                                float4 positionCS : SV_POSITION;
                                #if UNITY_ANY_INSTANCING_ENABLED
                                uint instanceID : CUSTOM_INSTANCE_ID;
                                #endif
                                float3 interp00 : TEXCOORD0;
                                #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                                uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
                                #endif
                                #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                                uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
                                #endif
                                #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                                FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
                                #endif
                            };

                            // Packed Type: Varyings
                            PackedVaryings PackVaryings(Varyings input)
                            {
                                PackedVaryings output = (PackedVaryings)0;
                                output.positionCS = input.positionCS;
                                output.interp00.xyz = input.positionWS;
                                #if UNITY_ANY_INSTANCING_ENABLED
                                output.instanceID = input.instanceID;
                                #endif
                                #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                                output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
                                #endif
                                #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                                output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
                                #endif
                                #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                                output.cullFace = input.cullFace;
                                #endif
                                return output;
                            }

                            // Unpacked Type: Varyings
                            Varyings UnpackVaryings(PackedVaryings input)
                            {
                                Varyings output = (Varyings)0;
                                output.positionCS = input.positionCS;
                                output.positionWS = input.interp00.xyz;
                                #if UNITY_ANY_INSTANCING_ENABLED
                                output.instanceID = input.instanceID;
                                #endif
                                #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                                output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
                                #endif
                                #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                                output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
                                #endif
                                #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                                output.cullFace = input.cullFace;
                                #endif
                                return output;
                            }

                            // --------------------------------------------------
                            // Build Graph Inputs

                            VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
                            {
                                VertexDescriptionInputs output;
                                ZERO_INITIALIZE(VertexDescriptionInputs, output);

                                output.ObjectSpaceNormal = input.normalOS;
                                output.ObjectSpaceTangent = input.tangentOS;
                                output.ObjectSpacePosition = input.positionOS;
                                output.uv0 = input.uv0;
                                output.TimeParameters = _TimeParameters.xyz;

                                return output;
                            }

                            SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
                            {
                                SurfaceDescriptionInputs output;
                                ZERO_INITIALIZE(SurfaceDescriptionInputs, output);





                                output.WorldSpacePosition = input.positionWS;
                                output.ScreenPosition = ComputeScreenPos(TransformWorldToHClip(input.positionWS), _ProjectionParams.x);
                            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                            #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
                            #else
                            #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
                            #endif
                            #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN

                                return output;
                            }


                            // --------------------------------------------------
                            // Main

                            #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
                            #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/PBR2DPass.hlsl"

                            ENDHLSL
                        }

        }
            CustomEditor "UnityEditor.ShaderGraph.PBRMasterGUI"
                                FallBack "Hidden/Shader Graph/FallbackError"
}
