Shader "Mirror/OilPic"
{
	//对某一像素，用它随机附近的一个像素来替代
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_Noise("noise", 2D) = "white" {}
		_Res("Noise Resolution",Float) = 128

	}
	SubShader
	{
		tags{ "Queue" = "Transparent" "RenderType" = "Transparent" }

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
		
			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;			
				float4 vertex : SV_POSITION;
			};

			sampler2D _MainTex;
			float4 _MainTex_ST;
			sampler2D _Noise;
			float4 _Noise_ST;
			float _Res;
			//xxx_TexelSize是Unity为我们提供的访问xxx纹理对应的每个纹素的大小。
			//例如，一张512x512大小的纹理，该值大约为0.001953(即1/512)。
			//由于卷积需要对相领区域内的纹理进行采样，因此我们需要利用_MainTex_TexelSize来计算各个
			//相邻区域的纹理坐标。
			float4 _MainTex_TexelSize;
			
			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				
				return o;
			}
					
			fixed4 frag (v2f i) : SV_Target
			{
				float n = tex2D(_Noise, i.uv).r;
				
				float range = n * _Res + 1;
				float sub = (range + 1) / 2;			
				float dd = n * range + 1;
				float2 uv_earth = i.uv + float2((dd - sub), (dd - sub)) * _MainTex_TexelSize.xy;



				float4 rc = tex2D(_MainTex, uv_earth);
		
				return rc;

			}
			ENDCG
		}
	}
}
