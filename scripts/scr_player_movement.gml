//Keyboard constants
//We use these so we can just type the variables
//instead of "keyboard_check(*)"

KEY_RIGHT=keyboard_check(vk_right);
KEY_LEFT=keyboard_check(vk_left);
KEY_JUMP=keyboard_check_pressed(vk_up); 
//This one's for variable jump height:
KEY_FALL=keyboard_check_released(vk_up);
//Now check if the player pressed left or right and move
if (KEY_RIGHT)
{
   hsp=walksp; //Walk right
   image_xscale=1; //Face right
}
if (KEY_LEFT)
{
   hsp=-walksp; //Walk left
   image_xscale=-1; //Face left
}
//Stop moving when no keys are pressed
if (!KEY_RIGHT and !KEY_LEFT) hsp=0;
//Make sure we don't hit a wall
if (place_meeting(x+hsp,y,obj_ground))
{
   //Move until contact with the wall
   if (hsp!=0)
      while (!place_meeting(x+sign(hsp),y,obj_ground))
         x+=sign(hsp);
   hsp=0;
}
//Because we don't use hspeed, we got to move ourselves
x+=hsp;
//Now for vertical motion (jumping and falling)
//Is the player in the air?
if (place_meeting(x,y+1,obj_ground)) grounded=1;
else grounded=0;
//Jump with the up key when on the ground
if (KEY_JUMP and grounded)
{
   vsp=jumpsp;
}
//If we're in air moving up and jump key is released, we remove
//upward motion (so we fall and get variable jump height)
if (KEY_FALL and !grounded and vsp<-1) vsp=-1;
//Fall with gravity
if (!grounded) vsp+=grav;
//Now it's more complicated.
//When hitting the ceiling, vertical speed must stop.
//The if statement says, "if we hit the ceiling and are moving up" 
if (place_meeting(x,y+vsp,obj_ground) && vsp<0)
{
   //We must move up until contact with the ceiling
   while (!place_meeting(x,y+sign(vsp),obj_ground)) y+=sign(vsp);
   vsp=0;
}
//But if we are moving down and hit the floor, we have to land
if (place_meeting(x,y+vsp,obj_ground) and vsp>0)
{
   //Move so we hit the ground
   var cc;
   cc=vsp+1; //A counter, so we don't get an infinite loop
   //Move down until we hit the floor
   while (!place_meeting(x,y+1,obj_ground) and cc>=0) y+=2;
        //Now ground the player
        grounded=1;
        vsp=0;
}
//Again, we're not using vspeed, so we have to move ourselves
y+=vsp;
//Animation - check what our sprite's state is and set accordingly
if (grounded) //If we're grounded
{
   if (hsp==0) //Then if we're not moving, change to stand sprite
   {
      sprite_index=spr_player_stand; //stand
      image_speed=0; //Don't animate
   }
   else //But if we are moving, change to walk sprite
   {
      //Reset image index if just now switching to walk sprite
      if (sprite_index!=spr_player_moving) image_index=0; //walking
      sprite_index=spr_player_moving;
      image_speed=0.5; //Change this to whatever works for you
   }
}
else //If we're not grounded, change to in air sprite
{
   sprite_index=spr_player_jumping;
   image_speed=0; //Don't animate
}
