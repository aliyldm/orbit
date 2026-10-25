package net.bigpoint.darkorbit.mvc.tdm.matchresultWindow.view.window.components.tooltip
{
   import flashx.textLayout.formats.TextAlign;
   import mx.core.IFlexModuleFactory;
   import net.bigpoint.darkorbit.mvc.tdm.matchresultWindow.consts.TDMResultWindowConstants;
   import net.bigpoint.darkorbit.mvc.tdm.matchresultWindow.view.window.components.vo.TDMRewardVo;
   
   public class TDMToolTipAmmountGridRenderer extends TDMAbstractToolTipGridRenderer
   {
      
      private var __moduleFactoryInitialized:Boolean = false;
      
      public function TDMToolTipAmmountGridRenderer()
      {
         super();
         mx_internal::_document = this;
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
      
      override public function set data(param1:Object) : void
      {
         super.data = param1;
         var _loc2_:TDMRewardVo = param1 as TDMRewardVo;
         if(_loc2_)
         {
            _text = _loc2_.ammount;
            _color = TDMResultWindowConstants.AMMOUNT_TEXT_COLOR;
            _textAlign = TextAlign.RIGHT;
         }
      }
   }
}

