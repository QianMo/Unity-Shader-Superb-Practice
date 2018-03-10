using UnityEngine;
using System.Collections;

public class PDS_GameController : MonoBehaviour 
{

	private Transform player;
	public Transform player1;
	public bool invert_vertical=false;
	public bool invert_horizontal=false;
	public float speed=1;
	//private bool isplayer1=true;

	private Vector2 _mouseReference;
	private Vector3 _rotation;
	private Vector2 _mouseOffset;
	public float rotate_speedX=1;
	public float rotate_speedY=1;

	// Use this for initialization
	void Start () 
	{
		player = player1;
	}
	
	// Update is called once per frame
	void Update () 
	{
		//WALK VERTICAL
		if (Input.GetKey(KeyCode.W) || Input.GetKey(KeyCode.UpArrow))
		{
			if(!invert_vertical)
				moveZ(player,false);
			else
				moveZ(player,true);
		}
		else
		{
			if (Input.GetKey(KeyCode.S) || Input.GetKey(KeyCode.DownArrow))
			{
				if(!invert_vertical)
					moveZ(player,true);
				else
					moveZ(player,false);
			}
		}

		//WALK HORIAONTAL
		if (Input.GetKey(KeyCode.A) || Input.GetKey(KeyCode.LeftArrow))
		{
			if(!invert_vertical)
				moveX(player,true);
			else
				moveX(player,false);
		}
		else
		{
			if (Input.GetKey(KeyCode.D) || Input.GetKey(KeyCode.RightArrow))
			{
				if(!invert_vertical)
					moveX(player,false);
				else
					moveX(player,true);
			}
		}

		//MOUSE DRAG TO ROTATE
		if (Input.GetMouseButtonDown(0))
		{
			_mouseReference.x = Input.mousePosition.x;
			_mouseReference.y = Input.mousePosition.y;
		}
		
		if (Input.GetMouseButton(0))
		{
			_mouseOffset.x = (Input.mousePosition.x - _mouseReference.x);
			_mouseOffset.y = (Input.mousePosition.y - _mouseReference.y);
								
			_rotation.y = -(_mouseOffset.x + _mouseOffset.x) * rotate_speedX;
			_rotation.x = -(_mouseOffset.y + _mouseOffset.y) * rotate_speedY;
			player.Rotate(_rotation);

			_mouseReference.x = Input.mousePosition.x;
			_mouseReference.y = Input.mousePosition.y;
		}
	}

	void moveZ(Transform theobj, bool positive)
	{
		if(positive)
			theobj.position += transform.forward*speed;
		else
			theobj.position -= transform.forward*speed;
	}

	void moveX(Transform theobj, bool positive)
	{
		if(positive)
			theobj.position += transform.right*speed;
		else
			theobj.position -= transform.right*speed;
	}


}
