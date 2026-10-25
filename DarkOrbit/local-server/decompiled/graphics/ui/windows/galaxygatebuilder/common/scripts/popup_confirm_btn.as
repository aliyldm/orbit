package
{
   import flash.display.MovieClip;
   import flash.text.TextField;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol264")]
   public dynamic class popup_confirm_btn extends MovieClip
   {
      
      public var btnText:TextField;
      
      public function popup_confirm_btn()
      {
         super();
         addFrameScript(0,this.frame1);
      }
      
      internal function frame1() : *
      {
         stop();
      }
   }
}

