package
{
   import flash.display.MovieClip;
   import flash.text.TextField;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol272")]
   public dynamic class popup_cancel_btn extends MovieClip
   {
      
      public var btnText:TextField;
      
      public function popup_cancel_btn()
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

