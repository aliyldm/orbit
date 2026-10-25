package net.bigpoint.darkorbit.mvc.hintSystem.model.vo
{
   import net.bigpoint.darkorbit.mvc.hintSystem.controller.hintWindow.HintSystemCloseWindowCommand;
   import net.bigpoint.darkorbit.net.JavascriptCallVO;
   
   public class HintSystemButtonActionDescriptionVO
   {
      
      private var _command:Class = HintSystemCloseWindowCommand;
      
      private var _externalInterfaceVO:JavascriptCallVO;
      
      private var _externalInterfaceMethodName:String;
      
      public function HintSystemButtonActionDescriptionVO(param1:Class = null, param2:JavascriptCallVO = null, param3:String = null)
      {
         super();
         if(param1 != null)
         {
            this._command = param1;
         }
         this._externalInterfaceVO = param2;
         this._externalInterfaceMethodName = param3;
      }
      
      public function get command() : Class
      {
         return this._command;
      }
      
      public function get externalInterfaceVO() : JavascriptCallVO
      {
         return this._externalInterfaceVO;
      }
      
      public function get externalInterfaceMethodName() : String
      {
         return this._externalInterfaceMethodName;
      }
   }
}

