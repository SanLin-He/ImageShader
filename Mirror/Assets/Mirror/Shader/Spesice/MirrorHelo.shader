Shader "Mirror/Helo"
{
	Properties{
		_MainTex("texture",2D) = "white"{}
		
		_CenterX("centerX",Range(0,1)) = 0.5
		_CenterY("centerY",Range(0,1)) = 0.5
		_Therash("therash", Range(0,0.5)) = 0.05
		_Instensity("instensity", Range(0,1)) = 0.1
	}
		SubShader{
		tags{ "Queue" = "Transparent" "RenderType" = "Transparent" }

		Pass{
		CGPROGRAM
			#pragma vertex vert  
			#pragma fragment frag  
			#include "UnityCG.cginc"  
			float4 _Color;
			sampler2D _MainTex;
			float _CenterX;
			float _CenterY;
			uniform float _Therash;
			float _Instensity;

			struct v2f {
				float4 pos : SV_POSITION;
				float2 uv : TEXCOORD0;
			};

			float4 _MainTex_ST;
			v2f vert(appdata_base v) {
				v2f o;
				o.pos = mul(UNITY_MATRIX_MVP,v.vertex);
				o.uv = TRANSFORM_TEX(v.texcoord,_MainTex);
				return o;
			};
			float newX = 0;
			float newY = 0;

			float _Radius;
			half4 frag(v2f i) :COLOR
			{
				float maxDistance =  _Therash;

				float tx = i.uv.x - _CenterX;
				float ty = i.uv.y - _CenterY;
				float distan = sqrt(tx*tx + ty*ty);

				
				float scale = 1.0 - distan / maxDistance;
				//边沿处理系数  
				float discardFactor = clamp(_Therash - distan, 0, 1) / _Therash;
				float4 color = tex2D(_MainTex, i.uv) + scale * _Instensity * discardFactor;
				return color;
			}
			ENDCG
		}
	}
		FallBack "Diffuse"
}
