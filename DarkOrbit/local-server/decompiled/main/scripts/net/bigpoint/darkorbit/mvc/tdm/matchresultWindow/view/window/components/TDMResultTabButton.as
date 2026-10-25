package net.bigpoint.darkorbit.mvc.tdm.matchresultWindow.view.window.components
{
   import mx.core.IFlexModuleFactory;
   import net.bigpoint.darkorbit.mvc.common.view.components.DOTabButtonBase;
   import net.bigpoint.darkorbit.mvc.tdm.matchresultWindow.view.window.components.vo.TDMResultWindowTabVo;
   
   public class TDMResultTabButton extends DOTabButtonBase
   {
      
      private static var _skinParts:Object = {
         "labelDisplay":false,
         "iconDisplay":false
      };
      
      private var __moduleFactoryInitialized:Boolean = false;
      
      public function TDMResultTabButton()
      {
         super();
      }
      
      override public function set moduleFactory(param1:IFlexModuleFactory) : void
      {
         super.moduleFactory = param1;
         if(this.__moduleFactoryInitialized)
         {
            return;
         }
         this.__moduleFactoryInitialized = true;
      }
      
      override public function initialize() : void
      {
         super.initialize();
      }
      
      override protected function setFactionIcon(param1:Object) : void
      {
         var _loc2_:TDMResultWindowTabVo = param1 as TDMResultWindowTabVo;
         if(_loc2_)
         {
            label = _loc2_.tabLable;
         }
      }
   }
}

