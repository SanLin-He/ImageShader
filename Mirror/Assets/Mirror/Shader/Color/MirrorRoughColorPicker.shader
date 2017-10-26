Shader "Mirror/RoughColorPicker"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_ChoosenColor("_ChoosenColor",color) = (1,1,1,1)
		_ColorErrorRange("_ColorErrorRange",Range(0,1)) = 0.01
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
				UNITY_FOG_COORDS(1)
				float4 vertex : SV_POSITION;
			};

			sampler2D _MainTex;
			float4 _MainTex_ST;
			float4 _ChoosenColor;
			float _ColorErrorRange;
			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				float4 c = tex2D(_MainTex, i.uv);
				float4 diff = c - _ChoosenColor;

				if (abs(diff.r) < _ColorErrorRange && abs(diff.g) < _ColorErrorRange && abs(diff.b) < _ColorErrorRange)
				{
					return c;
				}
				return float4(0,0,0,0);

			}
			ENDCG
		}
	}
}
