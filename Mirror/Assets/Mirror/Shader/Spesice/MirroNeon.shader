//霓虹
//对于3 * 3点阵，首先计算原图象像素f(i, j)的红，绿，蓝分量与相同行f（i + 1，j）及同列f(i, j + 1)相邻象素的梯度，即差的平方之和的平方根，然后将梯度值作为处理后的象素g(i, j)的红，绿，蓝分量值。
//设r1, g1, b1分别为原图象象素f(i, j)的红，绿，蓝分量值，r2, g2, b2分别为相同行相邻象素f(i + 1, j)的红，绿，蓝分量值，r3, g3, b3分别为同列相邻象素f(i, j + 1)的红，绿，蓝分量值，rr, gg, bb为处理后象素g(i, j)的红，绿，蓝分量值，则：
//rr1 = (r1 - r2) ^ 2  rr2 = (r1 - r3) ^ 2
//gg1 = (g1 - g2) ^ 2  gg2 = (g1 - g3) ^ 2
//bb1 = (b1 - b2) ^ 2  bb2(b1 - b3) ^ 2
//rr = 2 * (rr1 + rr2) ^ 0.5
//gg = 2 * (gg1 + gg2) ^ 0.5
//bb = 2 * (bb1 + bb2) ^ 0.5
Shader "Mirro/Neno"
{
	Properties{
		_MainTex("MainTex", 2D) = "white" {}
		_BackColorInstensity("BackColorInstensity", Range(0,0.5)) = 0.4
		//边缘线强度
		_EdgeOnly("Edge Only", Range(0,1)) = 1.0
		//背景颜色
		_BackgroundColor("Background Color", Color) = (1, 1, 1, 1)
	}
		SubShader{
		pass {

		Tags{ "LightMode" = "ForwardBase" }
			Cull off

			CGPROGRAM
				#pragma vertex vert  
				#pragma fragment frag  
				#include "UnityCG.cginc"  


				sampler2D _MainTex;
				float4 _MainTex_ST;
		
				float4 _MainTex_TexelSize;
				float _BackColorInstensity;
				fixed _EdgeOnly;
				fixed4 _BackgroundColor;

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
			
					float4 mc00 = tex2D(_MainTex, i.uv_MainTex);//当前点的颜色  
					float4 mc10 = tex2D(_MainTex, i.uv_MainTex + fixed2(1,0) * _MainTex_TexelSize.xy);//同行（偏移了（1,0）个单位）的点的颜色，
					float4 mc01 = tex2D(_MainTex, i.uv_MainTex + fixed2(0,1) * _MainTex_TexelSize.xy);//同列（偏移了（0,1）个单位）的点的颜色

					float4 edageColor = 2 * sqrt(((mc00 - mc10) *(mc00 - mc10) + (mc00 - mc01)*(mc00 - mc01)));
			 

					//计算背景为原图下的颜色值
					fixed4 withEdgeColor = lerp(edageColor, tex2D(_MainTex, i.uv_MainTex), _BackColorInstensity);
					//计算背景为纯色下的颜色值
					fixed4 onlyEdgeColor = lerp(edageColor, _BackgroundColor, _BackColorInstensity);
					//利用_EdgeOnly在两者之间插值得到最终的像素值。
					return lerp(withEdgeColor, onlyEdgeColor, _EdgeOnly);
			
				}
			ENDCG
	}

	}
}
