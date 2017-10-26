Shader "Mirror/BlowUpWithEdge"
{

	Properties{
		_MainTex("texture",2D) = "white"{}
		_Radius("radius",Range(0,0.5)) = 0.2
		_CenterX("centerX",Range(0,1)) = 0.5
		_CenterY("centerY",Range(0,1)) = 0.5
		_Instensity("instensity", Range(1,5)) = 2
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
			uniform float _Instensity;
			
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

			uniform float _Radius;
			half4 frag(v2f i) :COLOR{
				
				float tx = i.uv.x - _CenterX;
				float ty = i.uv.y - _CenterY;

				float distan = tx*tx + ty*ty;

				float p = _Instensity *  _Radius / sqrt(distan);
				if (distan < _Radius*_Radius) {
					newX = tx / p;
					newY = ty / p;
	
					newX = newX + _CenterX;
					newY = newY + _CenterY;

				}
				else {
					newX = i.uv.x;
					newY = i.uv.y;
				}

				float u_x = newX;
				float u_y = newY;
				float2 uv_earth = float2(u_x,u_y);
				half4 texcolor_earth = tex2D(_MainTex,uv_earth);
				return texcolor_earth;
			}
				ENDCG
		}
	}
	FallBack "Diffuse"
}
