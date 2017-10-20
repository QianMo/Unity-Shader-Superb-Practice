Shader "ShaderSuperb/Session1/1-FirstShader"
{
	Properties
	{
		_Color("Color",Color)=(1,1,1,1) //float4
		_Int("Int",Int)=666
		_Float("Float",Float)=666.0
		_Vector("Vector",Vector)=(1,2,3,4)//float4
		_Range("Range",Range(1,66))=6
		_2D("Texture",2D)="blue"{}
		_Cube("Cube",Cube)="white"{}
		_3D("Texture",3D)="black"{}
	}

	//至少一个SubShader，从上到下找到第一个可全部支持的SubShader运行
	SubShader
	{
		//至少一个Pass
		Pass
		{
			CGPROGRAM

			ENDCG
		}

	}
	//由于没有vert和fragment函数，需指定fallback，不用fallback就会报错
	Fallback "VertexLit"
}