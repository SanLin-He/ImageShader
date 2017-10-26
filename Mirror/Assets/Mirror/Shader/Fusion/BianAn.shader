//变暗
Shader "Mirror/BianAn"
{
	Properties
	{
		_Base ("Texture", 2D) = "white" {}
		_Top("top", 2D) = "white" {}

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
			
			
			float colorBlend(float scale, float dest, float src) {
				return (scale * dest + (1.0 - scale) * src);
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				
				float4 c = tex2D(_Base, i.uv);
				float4 c2 = tex2D(_Top, i.uv_t);

				float4 result = c2 > c ? c : c2;

				return result;

			}
			ENDCG
		}
	}
}
