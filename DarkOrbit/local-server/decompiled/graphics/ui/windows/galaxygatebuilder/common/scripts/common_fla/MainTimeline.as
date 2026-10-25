package common_fla
{
   import flash.display.MovieClip;
   import flash.system.Security;
   
   [SWF(width="550", height="400", backgroundColor="#666666", frameRate="12")]
   public dynamic class MainTimeline extends MovieClip
   {
      
      public function MainTimeline()
      {
         super();
         addFrameScript(0,this.frame1);
      }
      
      internal function frame1() : *
      {
         Security.allowDomain("*");
      }
   }
}

