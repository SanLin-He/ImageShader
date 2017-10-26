Shader "Mirror/WaterColor" {
	Properties{
		_MainTex("image", 2D) = "white" {}
		_NoiseTex("noise", 2D) = "bump" {}
		_percent("percent", Range(0.5, 1.5)) = 0
		
	}
		SubShader{
			Tags{ "Queue" = "Transparent" }
			ZWrite Off
			Blend SrcAlpha OneMinusSrcAlpha
			
			Pass{
				CGPROGRAM
					#include "UnityCG.cginc"             
					#pragma vertex vert      
					#pragma fragment frag      



					sampler2D _MainTex;
					sampler2D _NoiseTex;
					float _percent;
					
					struct v2f {
						half4 pos:SV_POSITION;
						half4 uv : TEXCOORD0;
					};

					v2f vert(appdata_full v) {
						v2f o;
						o.pos = mul(UNITY_MATRIX_MVP, v.vertex);
						o.uv.xy = v.texcoord.xy;
						o.uv.zw = v.texcoord.xy + _Time.xx;
						return o;
					}

					fixed4 frag(v2f i) :SV_Target
					{
						// 原始卡牌, 把alpha设置为1，屏蔽掉alpha通道信息  
						fixed4 tex0 = tex2D(_MainTex, i.uv.xy);
						//tex0.a = 1;
						// 透明躁动卡牌; 使用alpha通道信息，设置显示颜色，并加入躁动；  
						half3 noise = tex2D(_NoiseTex, i.uv.zw);
						fixed4 tex1 = tex2D(_MainTex, i.uv.xy + noise.xy * 0.05 - 0.025);					
						return lerp(tex0, tex1, smoothstep(0, 0.3, i.uv.z *_percent));
					}
				ENDCG
		}
	}
	FallBack Off
}