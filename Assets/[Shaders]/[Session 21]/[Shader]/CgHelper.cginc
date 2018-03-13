#define PI 3.1415926535897932384626433f

float Vector3Length(float3 v)
{
	return sqrt(v.x*v.x+v.y*v.y+v.z*v.z);
}

float Vector2Length(float2 v)
{
	return sqrt(v.x*v.x+v.y*v.y);
}

float Vector3Angle(float3 a,float3 b)
{
	return (a.x*b.x+a.y*b.y+a.z*b.z)/(Vector3Length(a)*Vector3Length(b));
}

float3 RefractedVector3(float3 v,float3 n,float n1,float n2)
{
	float vAngle = Vector3Angle(v,n);
	return((n1/n2)*normalize(v)+(-1*(n1/n2)*vAngle+cos((n1/n2)*vAngle))*(normalize(n)));
}