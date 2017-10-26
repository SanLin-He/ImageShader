//亮光
Shader "Mirror/LiangGuang"
{
	Properties
	{
		_Base ("Texture", 2D) = "white" {}
		_Top("noise", 2D) = "white" {}
		_Res("Noise Resolution",Float) = 1
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
				float2 uv_t :  TEXCOORD1;
				float4 vertex : SV_POSITION;
			};

			sampler2D _Base;
			float4 _Base_ST;
			float _Res;
			sampler2D _Top;
			float4 _Top_ST;

			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = TRANSFORM_TEX(v.uv, _Base);
				o.uv_t = TRANSFORM_TEX(v.uv, _Top);
				
				return o;
			}
			
		
			float noise(float n) {
				return n * 0.5 + 0.5;
			}
			
			float colorBlend(float scale, float dest, float src) {
				return (scale * dest + (1.0 - scale) * src);
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				
				float4 c = tex2D(_Base, i.uv);
				float4 c2 = tex2D(_Top, i.uv_t);

				float4 result = c2 < 0.5 ? (c2 == 0 ? 2 * c2 : max(0, (1 - ((1 - c)) / (2 * c2)))) : ((2 * (c2 - 0.5)) == 1 ? (2 * (c2 - 0.5)) : min(1, ((c) / (1 - (2 * (c2 - 0.5))))));

				return result;

			}
			ENDCG
		}
	}
}
