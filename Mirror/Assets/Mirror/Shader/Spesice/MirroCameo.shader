//浮雕凸
Shader "Mirro/Cameo"
{
	Properties{
		_MainTex("MainTex", 2D) = "white" {}
		_Color("Main Color",color) = (1,1,1,1)
		_Instensity("Instensity", Range(0,1)) = 0.4
	}
		SubShader{
		pass {

		Tags{ "LightMode" = "ForwardBase" }
			Cull off

			CGPROGRAM
				#pragma vertex vert  
				#pragma fragment frag  
				#include "UnityCG.cginc"  

				float4 _Color;
		
				sampler2D _MainTex;
				float4 _MainTex_ST;
				//xxx_TexelSize是Unity为我们提供的访问xxx纹理对应的每个纹素的大小。
				//例如，一张512x512大小的纹理，该值大约为0.001953(即1/512)。
				//由于卷积需要对相领区域内的纹理进行采样，因此我们需要利用_MainTex_TexelSize来计算各个
				//相邻区域的纹理坐标。
				float4 _MainTex_TexelSize;
				float _Instensity;

				struct v2f {
					float4 pos:SV_POSITION;
					float2 uv_MainTex:TEXCOORD0;

				};

				v2f vert(appdata_full v) {
					v2f o;
					o.pos = mul(UNITY_MATRIX_MVP,v.vertex);
					o.uv_MainTex = TRANSFORM_TEX(v.texcoord,_MainTex);
					return o;
				}

				float4 frag(v2f i) :COLOR
				{
					//浮雕就是对图像上的一个像素和它右下的那个像素的色差的一种处理  
					float3 mc00 = tex2D(_MainTex, i.uv_MainTex).rgb;//当前点的颜色  
					float3 mc11 = tex2D(_MainTex, i.uv_MainTex + fixed2(1,1) * _MainTex_TexelSize.xy).rgb;//当前点右下角（偏移了（1,1）个单位）的点的颜色，  

					float3 diffs = mc00 - mc11;//diffs为亮点颜色差  
					//return float4(diffs + _Instensity, 1)* _Color;;

					float max0 = abs(diffs.r) > abs(diffs.g) ? diffs.r : diffs.g;
					max0 = abs(max0) > abs(diffs.b) ? max0 : diffs.b;//求出色差中rgb的最大值设为色差数  
					float gray = clamp(max0 + _Instensity, 0, 1);//灰度值其实就是这个色差数  
					return float4(gray.xxx, 1);//最终颜色  
				}
			ENDCG
	}

	}
}
