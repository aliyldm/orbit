package net.bigpoint.darkorbit.mvc.hintSystem.model.vo
{
   import net.bigpoint.darkorbit.mvc.hintSystem.model.content.IHintSystemContentDescription;
   
   public class HintSystemHintWindowOnActionVO
   {
      
      private var _notificationName:String;
      
      private var _contentVO:IHintSystemContentDescription;
      
      public function HintSystemHintWindowOnActionVO()
      {
         super();
      }
      
      public function get notificationName() : String
      {
         return this._notificationName;
      }
      
      public function set notificationName(param1:String) : void
      {
         this._notificationName = param1;
      }
      
      public function set contentVO(param1:IHintSystemContentDescription) : void
      {
         this._contentVO = param1;
      }
      
      public function get contentVO() : IHintSystemContentDescription
      {
         return this._contentVO;
      }
   }
}

