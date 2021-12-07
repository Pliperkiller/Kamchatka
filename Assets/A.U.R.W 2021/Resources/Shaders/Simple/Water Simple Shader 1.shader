Shader "ABKaspo/A.U.R.W/Simple/Water simple"
{
    Properties
    {
        _Depth("Depth", Float) = 0
        _DepthStrength("Deepth Strength", Range(0, 2)) = 0
        _ShallowWaterColor("Shallow Water Color", Color) = (0, 0.8749211, 1, 1)
        _Deep_Water_Color("Deep Water Color", Color) = (0.2685564, 0.8018868, 0.8018868, 1)
        [NoScaleOffset]_MainNormal("Main Normal", 2D) = "white" {}
        [NoScaleOffset]_SecondNormal("SecondNormal", 2D) = "white" {}
        _NormalTiling("Normal Tilng", Float) = 1
        _NormalStrength("Normal Strength", Range(0, 1)) = 0.1
        _Smothness("Smothness", Range(0, 1)) = 1
        _Displacement("Displacement", Float) = 0.5
        _DisplacementsPeed("Displacement Speed", Range(0, 500)) = 100
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
            #define _NORMALMAP 1
            #define _NORMAL_DROPOFF_TS 1
            #define ATTRIBUTES_NEED_NORMAL
            #define ATTRIBUTES_NEED_TANGENT
            #define ATTRIBUTES_NEED_TEXCOORD0
            #define ATTRIBUTES_NEED_TEXCOORD1
            #define VARYINGS_NEED_POSITION_WS 
            #define VARYINGS_NEED_NORMAL_WS
            #define VARYINGS_NEED_TANGENT_WS
            #define VARYINGS_NEED_TEXCOORD0
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
            float _Depth;
            float _DepthStrength;
            float4 _ShallowWaterColor;
            float4 _Deep_Water_Color;
            float _NormalTiling;
            float _NormalStrength;
            float _Smothness;
            float _Displacement;
            float _DisplacementsPeed;
            CBUFFER_END
            TEXTURE2D(_MainNormal); SAMPLER(sampler_MainNormal); float4 _MainNormal_TexelSize;
            TEXTURE2D(_SecondNormal); SAMPLER(sampler_SecondNormal); float4 _SecondNormal_TexelSize;
            SAMPLER(_SampleTexture2D_239FB604_Sampler_3_Linear_Repeat);
            SAMPLER(_SampleTexture2D_BAD61972_Sampler_3_Linear_Repeat);

            // Graph Functions

            void Unity_Divide_float(float A, float B, out float Out)
            {
                Out = A / B;
            }

            void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
            {
                Out = UV * Tiling + Offset;
            }


            float2 Unity_GradientNoise_Dir_float(float2 p)
            {
                // Permutation and hashing used in webgl-nosie goo.gl/pX7HtC
                p = p % 289;
                float x = (34 * p.x + 1) * p.x % 289 + p.y;
                x = (34 * x + 1) * x % 289;
                x = frac(x / 41) * 2 - 1;
                return normalize(float2(x - floor(x + 0.5), abs(x) - 0.5));
            }

            void Unity_GradientNoise_float(float2 UV, float Scale, out float Out)
            {
                float2 p = UV * Scale;
                float2 ip = floor(p);
                float2 fp = frac(p);
                float d00 = dot(Unity_GradientNoise_Dir_float(ip), fp);
                float d01 = dot(Unity_GradientNoise_Dir_float(ip + float2(0, 1)), fp - float2(0, 1));
                float d10 = dot(Unity_GradientNoise_Dir_float(ip + float2(1, 0)), fp - float2(1, 0));
                float d11 = dot(Unity_GradientNoise_Dir_float(ip + float2(1, 1)), fp - float2(1, 1));
                fp = fp * fp * fp * (fp * (fp * 6 - 15) + 10);
                Out = lerp(lerp(d00, d01, fp.y), lerp(d10, d11, fp.y), fp.x) + 0.5;
            }

            void Unity_Multiply_float(float A, float B, out float Out)
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

            void Unity_Add_float4(float4 A, float4 B, out float4 Out)
            {
                Out = A + B;
            }

            void Unity_Lerp_float(float A, float B, float T, out float Out)
            {
                Out = lerp(A, B, T);
            }

            void Unity_NormalStrength_float(float3 In, float Strength, out float3 Out)
            {
                Out = float3(In.rg * Strength, lerp(1, In.b, saturate(Strength)));
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
                float _Split_14A99BAE_R_1 = IN.ObjectSpacePosition[0];
                float _Split_14A99BAE_G_2 = IN.ObjectSpacePosition[1];
                float _Split_14A99BAE_B_3 = IN.ObjectSpacePosition[2];
                float _Split_14A99BAE_A_4 = 0;
                float _Property_3C03A380_Out_0 = _Displacement;
                float _Property_C60DAE94_Out_0 = _DisplacementsPeed;
                float _Divide_C184E5E4_Out_2;
                Unity_Divide_float(IN.TimeParameters.x, _Property_C60DAE94_Out_0, _Divide_C184E5E4_Out_2);
                float2 _TilingAndOffset_4A9F631A_Out_3;
                Unity_TilingAndOffset_float(IN.uv0.xy, float2 (1, 1), (_Divide_C184E5E4_Out_2.xx), _TilingAndOffset_4A9F631A_Out_3);
                float _GradientNoise_E23A37EA_Out_2;
                Unity_GradientNoise_float(_TilingAndOffset_4A9F631A_Out_3, 50, _GradientNoise_E23A37EA_Out_2);
                float _Multiply_DE1E019_Out_2;
                Unity_Multiply_float(_Property_3C03A380_Out_0, _GradientNoise_E23A37EA_Out_2, _Multiply_DE1E019_Out_2);
                float4 _Combine_6D98E9F1_RGBA_4;
                float3 _Combine_6D98E9F1_RGB_5;
                float2 _Combine_6D98E9F1_RG_6;
                Unity_Combine_float(_Split_14A99BAE_R_1, _Multiply_DE1E019_Out_2, _Split_14A99BAE_B_3, 0, _Combine_6D98E9F1_RGBA_4, _Combine_6D98E9F1_RGB_5, _Combine_6D98E9F1_RG_6);
                description.VertexPosition = _Combine_6D98E9F1_RGB_5;
                description.VertexNormal = IN.ObjectSpaceNormal;
                description.VertexTangent = IN.ObjectSpaceTangent;
                return description;
            }

            // Graph Pixel
            struct SurfaceDescriptionInputs
            {
                float3 WorldSpacePosition;
                float4 ScreenPosition;
                float4 uv0;
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
                float4 _Property_FD13AF40_Out_0 = _ShallowWaterColor;
                float4 _Property_8B8C7F44_Out_0 = _Deep_Water_Color;
                float _SceneDepth_390C7172_Out_1;
                Unity_SceneDepth_Linear01_float(float4(IN.ScreenPosition.xy / IN.ScreenPosition.w, 0, 0), _SceneDepth_390C7172_Out_1);
                float _Multiply_E124A66D_Out_2;
                Unity_Multiply_float(_SceneDepth_390C7172_Out_1, _ProjectionParams.z, _Multiply_E124A66D_Out_2);
                float4 _ScreenPosition_D9135C6E_Out_0 = IN.ScreenPosition;
                float _Split_886AAA60_R_1 = _ScreenPosition_D9135C6E_Out_0[0];
                float _Split_886AAA60_G_2 = _ScreenPosition_D9135C6E_Out_0[1];
                float _Split_886AAA60_B_3 = _ScreenPosition_D9135C6E_Out_0[2];
                float _Split_886AAA60_A_4 = _ScreenPosition_D9135C6E_Out_0[3];
                float _Property_8010CDC2_Out_0 = _Depth;
                float _Add_120FBF59_Out_2;
                Unity_Add_float(_Split_886AAA60_A_4, _Property_8010CDC2_Out_0, _Add_120FBF59_Out_2);
                float _Subtract_290AF037_Out_2;
                Unity_Subtract_float(_Multiply_E124A66D_Out_2, _Add_120FBF59_Out_2, _Subtract_290AF037_Out_2);
                float _Property_4B1E9A75_Out_0 = _DepthStrength;
                float _Multiply_E5843439_Out_2;
                Unity_Multiply_float(_Subtract_290AF037_Out_2, _Property_4B1E9A75_Out_0, _Multiply_E5843439_Out_2);
                float _Clamp_AA5D45A_Out_3;
                Unity_Clamp_float(_Multiply_E5843439_Out_2, 0, 1, _Clamp_AA5D45A_Out_3);
                float4 _Lerp_C78AD56D_Out_3;
                Unity_Lerp_float4(_Property_FD13AF40_Out_0, _Property_8B8C7F44_Out_0, (_Clamp_AA5D45A_Out_3.xxxx), _Lerp_C78AD56D_Out_3);
                float _Property_397D5837_Out_0 = _NormalTiling;
                float _Divide_87B7A77A_Out_2;
                Unity_Divide_float(IN.TimeParameters.x, 50, _Divide_87B7A77A_Out_2);
                float2 _TilingAndOffset_BE07614F_Out_3;
                Unity_TilingAndOffset_float(IN.uv0.xy, (_Property_397D5837_Out_0.xx), (_Divide_87B7A77A_Out_2.xx), _TilingAndOffset_BE07614F_Out_3);
                float4 _SampleTexture2D_239FB604_RGBA_0 = SAMPLE_TEXTURE2D(_MainNormal, sampler_MainNormal, _TilingAndOffset_BE07614F_Out_3);
                _SampleTexture2D_239FB604_RGBA_0.rgb = UnpackNormal(_SampleTexture2D_239FB604_RGBA_0);
                float _SampleTexture2D_239FB604_R_4 = _SampleTexture2D_239FB604_RGBA_0.r;
                float _SampleTexture2D_239FB604_G_5 = _SampleTexture2D_239FB604_RGBA_0.g;
                float _SampleTexture2D_239FB604_B_6 = _SampleTexture2D_239FB604_RGBA_0.b;
                float _SampleTexture2D_239FB604_A_7 = _SampleTexture2D_239FB604_RGBA_0.a;
                float _Divide_8FF7823B_Out_2;
                Unity_Divide_float(IN.TimeParameters.x, -25, _Divide_8FF7823B_Out_2);
                float2 _TilingAndOffset_BD05EA91_Out_3;
                Unity_TilingAndOffset_float(IN.uv0.xy, (_Property_397D5837_Out_0.xx), (_Divide_8FF7823B_Out_2.xx), _TilingAndOffset_BD05EA91_Out_3);
                float4 _SampleTexture2D_BAD61972_RGBA_0 = SAMPLE_TEXTURE2D(_SecondNormal, sampler_SecondNormal, _TilingAndOffset_BD05EA91_Out_3);
                _SampleTexture2D_BAD61972_RGBA_0.rgb = UnpackNormal(_SampleTexture2D_BAD61972_RGBA_0);
                float _SampleTexture2D_BAD61972_R_4 = _SampleTexture2D_BAD61972_RGBA_0.r;
                float _SampleTexture2D_BAD61972_G_5 = _SampleTexture2D_BAD61972_RGBA_0.g;
                float _SampleTexture2D_BAD61972_B_6 = _SampleTexture2D_BAD61972_RGBA_0.b;
                float _SampleTexture2D_BAD61972_A_7 = _SampleTexture2D_BAD61972_RGBA_0.a;
                float4 _Add_C3569082_Out_2;
                Unity_Add_float4(_SampleTexture2D_239FB604_RGBA_0, _SampleTexture2D_BAD61972_RGBA_0, _Add_C3569082_Out_2);
                float _Property_DF42DD97_Out_0 = _NormalStrength;
                float _Lerp_9A634AE2_Out_3;
                Unity_Lerp_float(0, _Property_DF42DD97_Out_0, _Clamp_AA5D45A_Out_3, _Lerp_9A634AE2_Out_3);
                float3 _NormalStrength_483F0B39_Out_2;
                Unity_NormalStrength_float((_Add_C3569082_Out_2.xyz), _Lerp_9A634AE2_Out_3, _NormalStrength_483F0B39_Out_2);
                float _Property_87C67C77_Out_0 = _Smothness;
                float _Split_6AD313F5_R_1 = _Lerp_C78AD56D_Out_3[0];
                float _Split_6AD313F5_G_2 = _Lerp_C78AD56D_Out_3[1];
                float _Split_6AD313F5_B_3 = _Lerp_C78AD56D_Out_3[2];
                float _Split_6AD313F5_A_4 = _Lerp_C78AD56D_Out_3[3];
                surface.Albedo = (_Lerp_C78AD56D_Out_3.xyz);
                surface.Normal = _NormalStrength_483F0B39_Out_2;
                surface.Emission = IsGammaSpace() ? float3(0, 0, 0) : SRGBToLinear(float3(0, 0, 0));
                surface.Metallic = 0;
                surface.Smoothness = _Property_87C67C77_Out_0;
                surface.Occlusion = 1;
                surface.Alpha = _Split_6AD313F5_A_4;
                surface.AlphaClipThreshold = 0;
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
                float4 texCoord0;
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
                float4 interp03 : TEXCOORD3;
                float3 interp04 : TEXCOORD4;
                float2 interp05 : TEXCOORD5;
                float3 interp06 : TEXCOORD6;
                float4 interp07 : TEXCOORD7;
                float4 interp08 : TEXCOORD8;
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
                output.interp03.xyzw = input.texCoord0;
                output.interp04.xyz = input.viewDirectionWS;
                #if defined(LIGHTMAP_ON)
                output.interp05.xy = input.lightmapUV;
                #endif
                #if !defined(LIGHTMAP_ON)
                output.interp06.xyz = input.sh;
                #endif
                output.interp07.xyzw = input.fogFactorAndVertexLight;
                output.interp08.xyzw = input.shadowCoord;
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
                output.texCoord0 = input.interp03.xyzw;
                output.viewDirectionWS = input.interp04.xyz;
                #if defined(LIGHTMAP_ON)
                output.lightmapUV = input.interp05.xy;
                #endif
                #if !defined(LIGHTMAP_ON)
                output.sh = input.interp06.xyz;
                #endif
                output.fogFactorAndVertexLight = input.interp07.xyzw;
                output.shadowCoord = input.interp08.xyzw;
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
                output.uv0 = input.texCoord0;
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
                #define _NORMALMAP 1
                #define _NORMAL_DROPOFF_TS 1
                #define ATTRIBUTES_NEED_NORMAL
                #define ATTRIBUTES_NEED_TANGENT
                #define ATTRIBUTES_NEED_TEXCOORD0
                #define VARYINGS_NEED_POSITION_WS 
                #define FEATURES_GRAPH_VERTEX
                #pragma multi_compile_instancing
                #define SHADERPASS_SHADOWCASTER
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
                float _Depth;
                float _DepthStrength;
                float4 _ShallowWaterColor;
                float4 _Deep_Water_Color;
                float _NormalTiling;
                float _NormalStrength;
                float _Smothness;
                float _Displacement;
                float _DisplacementsPeed;
                CBUFFER_END
                TEXTURE2D(_MainNormal); SAMPLER(sampler_MainNormal); float4 _MainNormal_TexelSize;
                TEXTURE2D(_SecondNormal); SAMPLER(sampler_SecondNormal); float4 _SecondNormal_TexelSize;

                // Graph Functions

                void Unity_Divide_float(float A, float B, out float Out)
                {
                    Out = A / B;
                }

                void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
                {
                    Out = UV * Tiling + Offset;
                }


                float2 Unity_GradientNoise_Dir_float(float2 p)
                {
                    // Permutation and hashing used in webgl-nosie goo.gl/pX7HtC
                    p = p % 289;
                    float x = (34 * p.x + 1) * p.x % 289 + p.y;
                    x = (34 * x + 1) * x % 289;
                    x = frac(x / 41) * 2 - 1;
                    return normalize(float2(x - floor(x + 0.5), abs(x) - 0.5));
                }

                void Unity_GradientNoise_float(float2 UV, float Scale, out float Out)
                {
                    float2 p = UV * Scale;
                    float2 ip = floor(p);
                    float2 fp = frac(p);
                    float d00 = dot(Unity_GradientNoise_Dir_float(ip), fp);
                    float d01 = dot(Unity_GradientNoise_Dir_float(ip + float2(0, 1)), fp - float2(0, 1));
                    float d10 = dot(Unity_GradientNoise_Dir_float(ip + float2(1, 0)), fp - float2(1, 0));
                    float d11 = dot(Unity_GradientNoise_Dir_float(ip + float2(1, 1)), fp - float2(1, 1));
                    fp = fp * fp * fp * (fp * (fp * 6 - 15) + 10);
                    Out = lerp(lerp(d00, d01, fp.y), lerp(d10, d11, fp.y), fp.x) + 0.5;
                }

                void Unity_Multiply_float(float A, float B, out float Out)
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
                    float _Split_14A99BAE_R_1 = IN.ObjectSpacePosition[0];
                    float _Split_14A99BAE_G_2 = IN.ObjectSpacePosition[1];
                    float _Split_14A99BAE_B_3 = IN.ObjectSpacePosition[2];
                    float _Split_14A99BAE_A_4 = 0;
                    float _Property_3C03A380_Out_0 = _Displacement;
                    float _Property_C60DAE94_Out_0 = _DisplacementsPeed;
                    float _Divide_C184E5E4_Out_2;
                    Unity_Divide_float(IN.TimeParameters.x, _Property_C60DAE94_Out_0, _Divide_C184E5E4_Out_2);
                    float2 _TilingAndOffset_4A9F631A_Out_3;
                    Unity_TilingAndOffset_float(IN.uv0.xy, float2 (1, 1), (_Divide_C184E5E4_Out_2.xx), _TilingAndOffset_4A9F631A_Out_3);
                    float _GradientNoise_E23A37EA_Out_2;
                    Unity_GradientNoise_float(_TilingAndOffset_4A9F631A_Out_3, 50, _GradientNoise_E23A37EA_Out_2);
                    float _Multiply_DE1E019_Out_2;
                    Unity_Multiply_float(_Property_3C03A380_Out_0, _GradientNoise_E23A37EA_Out_2, _Multiply_DE1E019_Out_2);
                    float4 _Combine_6D98E9F1_RGBA_4;
                    float3 _Combine_6D98E9F1_RGB_5;
                    float2 _Combine_6D98E9F1_RG_6;
                    Unity_Combine_float(_Split_14A99BAE_R_1, _Multiply_DE1E019_Out_2, _Split_14A99BAE_B_3, 0, _Combine_6D98E9F1_RGBA_4, _Combine_6D98E9F1_RGB_5, _Combine_6D98E9F1_RG_6);
                    description.VertexPosition = _Combine_6D98E9F1_RGB_5;
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
                    float Alpha;
                    float AlphaClipThreshold;
                };

                SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
                {
                    SurfaceDescription surface = (SurfaceDescription)0;
                    float4 _Property_FD13AF40_Out_0 = _ShallowWaterColor;
                    float4 _Property_8B8C7F44_Out_0 = _Deep_Water_Color;
                    float _SceneDepth_390C7172_Out_1;
                    Unity_SceneDepth_Linear01_float(float4(IN.ScreenPosition.xy / IN.ScreenPosition.w, 0, 0), _SceneDepth_390C7172_Out_1);
                    float _Multiply_E124A66D_Out_2;
                    Unity_Multiply_float(_SceneDepth_390C7172_Out_1, _ProjectionParams.z, _Multiply_E124A66D_Out_2);
                    float4 _ScreenPosition_D9135C6E_Out_0 = IN.ScreenPosition;
                    float _Split_886AAA60_R_1 = _ScreenPosition_D9135C6E_Out_0[0];
                    float _Split_886AAA60_G_2 = _ScreenPosition_D9135C6E_Out_0[1];
                    float _Split_886AAA60_B_3 = _ScreenPosition_D9135C6E_Out_0[2];
                    float _Split_886AAA60_A_4 = _ScreenPosition_D9135C6E_Out_0[3];
                    float _Property_8010CDC2_Out_0 = _Depth;
                    float _Add_120FBF59_Out_2;
                    Unity_Add_float(_Split_886AAA60_A_4, _Property_8010CDC2_Out_0, _Add_120FBF59_Out_2);
                    float _Subtract_290AF037_Out_2;
                    Unity_Subtract_float(_Multiply_E124A66D_Out_2, _Add_120FBF59_Out_2, _Subtract_290AF037_Out_2);
                    float _Property_4B1E9A75_Out_0 = _DepthStrength;
                    float _Multiply_E5843439_Out_2;
                    Unity_Multiply_float(_Subtract_290AF037_Out_2, _Property_4B1E9A75_Out_0, _Multiply_E5843439_Out_2);
                    float _Clamp_AA5D45A_Out_3;
                    Unity_Clamp_float(_Multiply_E5843439_Out_2, 0, 1, _Clamp_AA5D45A_Out_3);
                    float4 _Lerp_C78AD56D_Out_3;
                    Unity_Lerp_float4(_Property_FD13AF40_Out_0, _Property_8B8C7F44_Out_0, (_Clamp_AA5D45A_Out_3.xxxx), _Lerp_C78AD56D_Out_3);
                    float _Split_6AD313F5_R_1 = _Lerp_C78AD56D_Out_3[0];
                    float _Split_6AD313F5_G_2 = _Lerp_C78AD56D_Out_3[1];
                    float _Split_6AD313F5_B_3 = _Lerp_C78AD56D_Out_3[2];
                    float _Split_6AD313F5_A_4 = _Lerp_C78AD56D_Out_3[3];
                    surface.Alpha = _Split_6AD313F5_A_4;
                    surface.AlphaClipThreshold = 0;
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
                    #define _NORMALMAP 1
                    #define _NORMAL_DROPOFF_TS 1
                    #define ATTRIBUTES_NEED_NORMAL
                    #define ATTRIBUTES_NEED_TANGENT
                    #define ATTRIBUTES_NEED_TEXCOORD0
                    #define VARYINGS_NEED_POSITION_WS 
                    #define FEATURES_GRAPH_VERTEX
                    #pragma multi_compile_instancing
                    #define SHADERPASS_DEPTHONLY
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
                    float _Depth;
                    float _DepthStrength;
                    float4 _ShallowWaterColor;
                    float4 _Deep_Water_Color;
                    float _NormalTiling;
                    float _NormalStrength;
                    float _Smothness;
                    float _Displacement;
                    float _DisplacementsPeed;
                    CBUFFER_END
                    TEXTURE2D(_MainNormal); SAMPLER(sampler_MainNormal); float4 _MainNormal_TexelSize;
                    TEXTURE2D(_SecondNormal); SAMPLER(sampler_SecondNormal); float4 _SecondNormal_TexelSize;

                    // Graph Functions

                    void Unity_Divide_float(float A, float B, out float Out)
                    {
                        Out = A / B;
                    }

                    void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
                    {
                        Out = UV * Tiling + Offset;
                    }


                    float2 Unity_GradientNoise_Dir_float(float2 p)
                    {
                        // Permutation and hashing used in webgl-nosie goo.gl/pX7HtC
                        p = p % 289;
                        float x = (34 * p.x + 1) * p.x % 289 + p.y;
                        x = (34 * x + 1) * x % 289;
                        x = frac(x / 41) * 2 - 1;
                        return normalize(float2(x - floor(x + 0.5), abs(x) - 0.5));
                    }

                    void Unity_GradientNoise_float(float2 UV, float Scale, out float Out)
                    {
                        float2 p = UV * Scale;
                        float2 ip = floor(p);
                        float2 fp = frac(p);
                        float d00 = dot(Unity_GradientNoise_Dir_float(ip), fp);
                        float d01 = dot(Unity_GradientNoise_Dir_float(ip + float2(0, 1)), fp - float2(0, 1));
                        float d10 = dot(Unity_GradientNoise_Dir_float(ip + float2(1, 0)), fp - float2(1, 0));
                        float d11 = dot(Unity_GradientNoise_Dir_float(ip + float2(1, 1)), fp - float2(1, 1));
                        fp = fp * fp * fp * (fp * (fp * 6 - 15) + 10);
                        Out = lerp(lerp(d00, d01, fp.y), lerp(d10, d11, fp.y), fp.x) + 0.5;
                    }

                    void Unity_Multiply_float(float A, float B, out float Out)
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
                        float _Split_14A99BAE_R_1 = IN.ObjectSpacePosition[0];
                        float _Split_14A99BAE_G_2 = IN.ObjectSpacePosition[1];
                        float _Split_14A99BAE_B_3 = IN.ObjectSpacePosition[2];
                        float _Split_14A99BAE_A_4 = 0;
                        float _Property_3C03A380_Out_0 = _Displacement;
                        float _Property_C60DAE94_Out_0 = _DisplacementsPeed;
                        float _Divide_C184E5E4_Out_2;
                        Unity_Divide_float(IN.TimeParameters.x, _Property_C60DAE94_Out_0, _Divide_C184E5E4_Out_2);
                        float2 _TilingAndOffset_4A9F631A_Out_3;
                        Unity_TilingAndOffset_float(IN.uv0.xy, float2 (1, 1), (_Divide_C184E5E4_Out_2.xx), _TilingAndOffset_4A9F631A_Out_3);
                        float _GradientNoise_E23A37EA_Out_2;
                        Unity_GradientNoise_float(_TilingAndOffset_4A9F631A_Out_3, 50, _GradientNoise_E23A37EA_Out_2);
                        float _Multiply_DE1E019_Out_2;
                        Unity_Multiply_float(_Property_3C03A380_Out_0, _GradientNoise_E23A37EA_Out_2, _Multiply_DE1E019_Out_2);
                        float4 _Combine_6D98E9F1_RGBA_4;
                        float3 _Combine_6D98E9F1_RGB_5;
                        float2 _Combine_6D98E9F1_RG_6;
                        Unity_Combine_float(_Split_14A99BAE_R_1, _Multiply_DE1E019_Out_2, _Split_14A99BAE_B_3, 0, _Combine_6D98E9F1_RGBA_4, _Combine_6D98E9F1_RGB_5, _Combine_6D98E9F1_RG_6);
                        description.VertexPosition = _Combine_6D98E9F1_RGB_5;
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
                        float Alpha;
                        float AlphaClipThreshold;
                    };

                    SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
                    {
                        SurfaceDescription surface = (SurfaceDescription)0;
                        float4 _Property_FD13AF40_Out_0 = _ShallowWaterColor;
                        float4 _Property_8B8C7F44_Out_0 = _Deep_Water_Color;
                        float _SceneDepth_390C7172_Out_1;
                        Unity_SceneDepth_Linear01_float(float4(IN.ScreenPosition.xy / IN.ScreenPosition.w, 0, 0), _SceneDepth_390C7172_Out_1);
                        float _Multiply_E124A66D_Out_2;
                        Unity_Multiply_float(_SceneDepth_390C7172_Out_1, _ProjectionParams.z, _Multiply_E124A66D_Out_2);
                        float4 _ScreenPosition_D9135C6E_Out_0 = IN.ScreenPosition;
                        float _Split_886AAA60_R_1 = _ScreenPosition_D9135C6E_Out_0[0];
                        float _Split_886AAA60_G_2 = _ScreenPosition_D9135C6E_Out_0[1];
                        float _Split_886AAA60_B_3 = _ScreenPosition_D9135C6E_Out_0[2];
                        float _Split_886AAA60_A_4 = _ScreenPosition_D9135C6E_Out_0[3];
                        float _Property_8010CDC2_Out_0 = _Depth;
                        float _Add_120FBF59_Out_2;
                        Unity_Add_float(_Split_886AAA60_A_4, _Property_8010CDC2_Out_0, _Add_120FBF59_Out_2);
                        float _Subtract_290AF037_Out_2;
                        Unity_Subtract_float(_Multiply_E124A66D_Out_2, _Add_120FBF59_Out_2, _Subtract_290AF037_Out_2);
                        float _Property_4B1E9A75_Out_0 = _DepthStrength;
                        float _Multiply_E5843439_Out_2;
                        Unity_Multiply_float(_Subtract_290AF037_Out_2, _Property_4B1E9A75_Out_0, _Multiply_E5843439_Out_2);
                        float _Clamp_AA5D45A_Out_3;
                        Unity_Clamp_float(_Multiply_E5843439_Out_2, 0, 1, _Clamp_AA5D45A_Out_3);
                        float4 _Lerp_C78AD56D_Out_3;
                        Unity_Lerp_float4(_Property_FD13AF40_Out_0, _Property_8B8C7F44_Out_0, (_Clamp_AA5D45A_Out_3.xxxx), _Lerp_C78AD56D_Out_3);
                        float _Split_6AD313F5_R_1 = _Lerp_C78AD56D_Out_3[0];
                        float _Split_6AD313F5_G_2 = _Lerp_C78AD56D_Out_3[1];
                        float _Split_6AD313F5_B_3 = _Lerp_C78AD56D_Out_3[2];
                        float _Split_6AD313F5_A_4 = _Lerp_C78AD56D_Out_3[3];
                        surface.Alpha = _Split_6AD313F5_A_4;
                        surface.AlphaClipThreshold = 0;
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
                        #define _NORMALMAP 1
                        #define _NORMAL_DROPOFF_TS 1
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
                        float _Depth;
                        float _DepthStrength;
                        float4 _ShallowWaterColor;
                        float4 _Deep_Water_Color;
                        float _NormalTiling;
                        float _NormalStrength;
                        float _Smothness;
                        float _Displacement;
                        float _DisplacementsPeed;
                        CBUFFER_END
                        TEXTURE2D(_MainNormal); SAMPLER(sampler_MainNormal); float4 _MainNormal_TexelSize;
                        TEXTURE2D(_SecondNormal); SAMPLER(sampler_SecondNormal); float4 _SecondNormal_TexelSize;

                        // Graph Functions

                        void Unity_Divide_float(float A, float B, out float Out)
                        {
                            Out = A / B;
                        }

                        void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
                        {
                            Out = UV * Tiling + Offset;
                        }


                        float2 Unity_GradientNoise_Dir_float(float2 p)
                        {
                            // Permutation and hashing used in webgl-nosie goo.gl/pX7HtC
                            p = p % 289;
                            float x = (34 * p.x + 1) * p.x % 289 + p.y;
                            x = (34 * x + 1) * x % 289;
                            x = frac(x / 41) * 2 - 1;
                            return normalize(float2(x - floor(x + 0.5), abs(x) - 0.5));
                        }

                        void Unity_GradientNoise_float(float2 UV, float Scale, out float Out)
                        {
                            float2 p = UV * Scale;
                            float2 ip = floor(p);
                            float2 fp = frac(p);
                            float d00 = dot(Unity_GradientNoise_Dir_float(ip), fp);
                            float d01 = dot(Unity_GradientNoise_Dir_float(ip + float2(0, 1)), fp - float2(0, 1));
                            float d10 = dot(Unity_GradientNoise_Dir_float(ip + float2(1, 0)), fp - float2(1, 0));
                            float d11 = dot(Unity_GradientNoise_Dir_float(ip + float2(1, 1)), fp - float2(1, 1));
                            fp = fp * fp * fp * (fp * (fp * 6 - 15) + 10);
                            Out = lerp(lerp(d00, d01, fp.y), lerp(d10, d11, fp.y), fp.x) + 0.5;
                        }

                        void Unity_Multiply_float(float A, float B, out float Out)
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
                            float _Split_14A99BAE_R_1 = IN.ObjectSpacePosition[0];
                            float _Split_14A99BAE_G_2 = IN.ObjectSpacePosition[1];
                            float _Split_14A99BAE_B_3 = IN.ObjectSpacePosition[2];
                            float _Split_14A99BAE_A_4 = 0;
                            float _Property_3C03A380_Out_0 = _Displacement;
                            float _Property_C60DAE94_Out_0 = _DisplacementsPeed;
                            float _Divide_C184E5E4_Out_2;
                            Unity_Divide_float(IN.TimeParameters.x, _Property_C60DAE94_Out_0, _Divide_C184E5E4_Out_2);
                            float2 _TilingAndOffset_4A9F631A_Out_3;
                            Unity_TilingAndOffset_float(IN.uv0.xy, float2 (1, 1), (_Divide_C184E5E4_Out_2.xx), _TilingAndOffset_4A9F631A_Out_3);
                            float _GradientNoise_E23A37EA_Out_2;
                            Unity_GradientNoise_float(_TilingAndOffset_4A9F631A_Out_3, 50, _GradientNoise_E23A37EA_Out_2);
                            float _Multiply_DE1E019_Out_2;
                            Unity_Multiply_float(_Property_3C03A380_Out_0, _GradientNoise_E23A37EA_Out_2, _Multiply_DE1E019_Out_2);
                            float4 _Combine_6D98E9F1_RGBA_4;
                            float3 _Combine_6D98E9F1_RGB_5;
                            float2 _Combine_6D98E9F1_RG_6;
                            Unity_Combine_float(_Split_14A99BAE_R_1, _Multiply_DE1E019_Out_2, _Split_14A99BAE_B_3, 0, _Combine_6D98E9F1_RGBA_4, _Combine_6D98E9F1_RGB_5, _Combine_6D98E9F1_RG_6);
                            description.VertexPosition = _Combine_6D98E9F1_RGB_5;
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
                            float4 _Property_FD13AF40_Out_0 = _ShallowWaterColor;
                            float4 _Property_8B8C7F44_Out_0 = _Deep_Water_Color;
                            float _SceneDepth_390C7172_Out_1;
                            Unity_SceneDepth_Linear01_float(float4(IN.ScreenPosition.xy / IN.ScreenPosition.w, 0, 0), _SceneDepth_390C7172_Out_1);
                            float _Multiply_E124A66D_Out_2;
                            Unity_Multiply_float(_SceneDepth_390C7172_Out_1, _ProjectionParams.z, _Multiply_E124A66D_Out_2);
                            float4 _ScreenPosition_D9135C6E_Out_0 = IN.ScreenPosition;
                            float _Split_886AAA60_R_1 = _ScreenPosition_D9135C6E_Out_0[0];
                            float _Split_886AAA60_G_2 = _ScreenPosition_D9135C6E_Out_0[1];
                            float _Split_886AAA60_B_3 = _ScreenPosition_D9135C6E_Out_0[2];
                            float _Split_886AAA60_A_4 = _ScreenPosition_D9135C6E_Out_0[3];
                            float _Property_8010CDC2_Out_0 = _Depth;
                            float _Add_120FBF59_Out_2;
                            Unity_Add_float(_Split_886AAA60_A_4, _Property_8010CDC2_Out_0, _Add_120FBF59_Out_2);
                            float _Subtract_290AF037_Out_2;
                            Unity_Subtract_float(_Multiply_E124A66D_Out_2, _Add_120FBF59_Out_2, _Subtract_290AF037_Out_2);
                            float _Property_4B1E9A75_Out_0 = _DepthStrength;
                            float _Multiply_E5843439_Out_2;
                            Unity_Multiply_float(_Subtract_290AF037_Out_2, _Property_4B1E9A75_Out_0, _Multiply_E5843439_Out_2);
                            float _Clamp_AA5D45A_Out_3;
                            Unity_Clamp_float(_Multiply_E5843439_Out_2, 0, 1, _Clamp_AA5D45A_Out_3);
                            float4 _Lerp_C78AD56D_Out_3;
                            Unity_Lerp_float4(_Property_FD13AF40_Out_0, _Property_8B8C7F44_Out_0, (_Clamp_AA5D45A_Out_3.xxxx), _Lerp_C78AD56D_Out_3);
                            float _Split_6AD313F5_R_1 = _Lerp_C78AD56D_Out_3[0];
                            float _Split_6AD313F5_G_2 = _Lerp_C78AD56D_Out_3[1];
                            float _Split_6AD313F5_B_3 = _Lerp_C78AD56D_Out_3[2];
                            float _Split_6AD313F5_A_4 = _Lerp_C78AD56D_Out_3[3];
                            surface.Albedo = (_Lerp_C78AD56D_Out_3.xyz);
                            surface.Emission = IsGammaSpace() ? float3(0, 0, 0) : SRGBToLinear(float3(0, 0, 0));
                            surface.Alpha = _Split_6AD313F5_A_4;
                            surface.AlphaClipThreshold = 0;
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
                            #define _NORMALMAP 1
                            #define _NORMAL_DROPOFF_TS 1
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
                            float _Depth;
                            float _DepthStrength;
                            float4 _ShallowWaterColor;
                            float4 _Deep_Water_Color;
                            float _NormalTiling;
                            float _NormalStrength;
                            float _Smothness;
                            float _Displacement;
                            float _DisplacementsPeed;
                            CBUFFER_END
                            TEXTURE2D(_MainNormal); SAMPLER(sampler_MainNormal); float4 _MainNormal_TexelSize;
                            TEXTURE2D(_SecondNormal); SAMPLER(sampler_SecondNormal); float4 _SecondNormal_TexelSize;

                            // Graph Functions

                            void Unity_Divide_float(float A, float B, out float Out)
                            {
                                Out = A / B;
                            }

                            void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
                            {
                                Out = UV * Tiling + Offset;
                            }


                            float2 Unity_GradientNoise_Dir_float(float2 p)
                            {
                                // Permutation and hashing used in webgl-nosie goo.gl/pX7HtC
                                p = p % 289;
                                float x = (34 * p.x + 1) * p.x % 289 + p.y;
                                x = (34 * x + 1) * x % 289;
                                x = frac(x / 41) * 2 - 1;
                                return normalize(float2(x - floor(x + 0.5), abs(x) - 0.5));
                            }

                            void Unity_GradientNoise_float(float2 UV, float Scale, out float Out)
                            {
                                float2 p = UV * Scale;
                                float2 ip = floor(p);
                                float2 fp = frac(p);
                                float d00 = dot(Unity_GradientNoise_Dir_float(ip), fp);
                                float d01 = dot(Unity_GradientNoise_Dir_float(ip + float2(0, 1)), fp - float2(0, 1));
                                float d10 = dot(Unity_GradientNoise_Dir_float(ip + float2(1, 0)), fp - float2(1, 0));
                                float d11 = dot(Unity_GradientNoise_Dir_float(ip + float2(1, 1)), fp - float2(1, 1));
                                fp = fp * fp * fp * (fp * (fp * 6 - 15) + 10);
                                Out = lerp(lerp(d00, d01, fp.y), lerp(d10, d11, fp.y), fp.x) + 0.5;
                            }

                            void Unity_Multiply_float(float A, float B, out float Out)
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
                                float _Split_14A99BAE_R_1 = IN.ObjectSpacePosition[0];
                                float _Split_14A99BAE_G_2 = IN.ObjectSpacePosition[1];
                                float _Split_14A99BAE_B_3 = IN.ObjectSpacePosition[2];
                                float _Split_14A99BAE_A_4 = 0;
                                float _Property_3C03A380_Out_0 = _Displacement;
                                float _Property_C60DAE94_Out_0 = _DisplacementsPeed;
                                float _Divide_C184E5E4_Out_2;
                                Unity_Divide_float(IN.TimeParameters.x, _Property_C60DAE94_Out_0, _Divide_C184E5E4_Out_2);
                                float2 _TilingAndOffset_4A9F631A_Out_3;
                                Unity_TilingAndOffset_float(IN.uv0.xy, float2 (1, 1), (_Divide_C184E5E4_Out_2.xx), _TilingAndOffset_4A9F631A_Out_3);
                                float _GradientNoise_E23A37EA_Out_2;
                                Unity_GradientNoise_float(_TilingAndOffset_4A9F631A_Out_3, 50, _GradientNoise_E23A37EA_Out_2);
                                float _Multiply_DE1E019_Out_2;
                                Unity_Multiply_float(_Property_3C03A380_Out_0, _GradientNoise_E23A37EA_Out_2, _Multiply_DE1E019_Out_2);
                                float4 _Combine_6D98E9F1_RGBA_4;
                                float3 _Combine_6D98E9F1_RGB_5;
                                float2 _Combine_6D98E9F1_RG_6;
                                Unity_Combine_float(_Split_14A99BAE_R_1, _Multiply_DE1E019_Out_2, _Split_14A99BAE_B_3, 0, _Combine_6D98E9F1_RGBA_4, _Combine_6D98E9F1_RGB_5, _Combine_6D98E9F1_RG_6);
                                description.VertexPosition = _Combine_6D98E9F1_RGB_5;
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
                                float4 _Property_FD13AF40_Out_0 = _ShallowWaterColor;
                                float4 _Property_8B8C7F44_Out_0 = _Deep_Water_Color;
                                float _SceneDepth_390C7172_Out_1;
                                Unity_SceneDepth_Linear01_float(float4(IN.ScreenPosition.xy / IN.ScreenPosition.w, 0, 0), _SceneDepth_390C7172_Out_1);
                                float _Multiply_E124A66D_Out_2;
                                Unity_Multiply_float(_SceneDepth_390C7172_Out_1, _ProjectionParams.z, _Multiply_E124A66D_Out_2);
                                float4 _ScreenPosition_D9135C6E_Out_0 = IN.ScreenPosition;
                                float _Split_886AAA60_R_1 = _ScreenPosition_D9135C6E_Out_0[0];
                                float _Split_886AAA60_G_2 = _ScreenPosition_D9135C6E_Out_0[1];
                                float _Split_886AAA60_B_3 = _ScreenPosition_D9135C6E_Out_0[2];
                                float _Split_886AAA60_A_4 = _ScreenPosition_D9135C6E_Out_0[3];
                                float _Property_8010CDC2_Out_0 = _Depth;
                                float _Add_120FBF59_Out_2;
                                Unity_Add_float(_Split_886AAA60_A_4, _Property_8010CDC2_Out_0, _Add_120FBF59_Out_2);
                                float _Subtract_290AF037_Out_2;
                                Unity_Subtract_float(_Multiply_E124A66D_Out_2, _Add_120FBF59_Out_2, _Subtract_290AF037_Out_2);
                                float _Property_4B1E9A75_Out_0 = _DepthStrength;
                                float _Multiply_E5843439_Out_2;
                                Unity_Multiply_float(_Subtract_290AF037_Out_2, _Property_4B1E9A75_Out_0, _Multiply_E5843439_Out_2);
                                float _Clamp_AA5D45A_Out_3;
                                Unity_Clamp_float(_Multiply_E5843439_Out_2, 0, 1, _Clamp_AA5D45A_Out_3);
                                float4 _Lerp_C78AD56D_Out_3;
                                Unity_Lerp_float4(_Property_FD13AF40_Out_0, _Property_8B8C7F44_Out_0, (_Clamp_AA5D45A_Out_3.xxxx), _Lerp_C78AD56D_Out_3);
                                float _Split_6AD313F5_R_1 = _Lerp_C78AD56D_Out_3[0];
                                float _Split_6AD313F5_G_2 = _Lerp_C78AD56D_Out_3[1];
                                float _Split_6AD313F5_B_3 = _Lerp_C78AD56D_Out_3[2];
                                float _Split_6AD313F5_A_4 = _Lerp_C78AD56D_Out_3[3];
                                surface.Albedo = (_Lerp_C78AD56D_Out_3.xyz);
                                surface.Alpha = _Split_6AD313F5_A_4;
                                surface.AlphaClipThreshold = 0;
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
