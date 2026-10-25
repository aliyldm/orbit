package net.bigpoint.darkorbit.mvc.hints.model
{
   import net.bigpoint.darkorbit.mvc.gui.common.abstract.model.DOAbstractProxy;
   
   public class HintsProxy extends DOAbstractProxy
   {
      
      public static const NAME:String = "HintsProxy";
      
      private var _currentHintId:String;
      
      public function HintsProxy()
      {
         super(NAME);
      }
      
      public function get currentHintId() : String
      {
         return this._currentHintId;
      }
      
      public function set currentHintId(param1:String) : void
      {
         this._currentHintId = param1;
      }
   }
}

