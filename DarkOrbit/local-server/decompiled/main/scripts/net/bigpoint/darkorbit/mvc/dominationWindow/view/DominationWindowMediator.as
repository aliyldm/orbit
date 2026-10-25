package net.bigpoint.darkorbit.mvc.dominationWindow.view
{
   import flash.display.Sprite;
   import net.bigpoint.darkorbit.fui.components.core.Container;
   import net.bigpoint.darkorbit.fui.components.core.Coreponent;
   import net.bigpoint.darkorbit.fui.components.core.data.VectorCollection;
   import net.bigpoint.darkorbit.fui.components.list.itemlist.ItemList;
   import net.bigpoint.darkorbit.fui.components.scroll.ScrollContainer;
   import net.bigpoint.darkorbit.fui.components.scroll.Scrollbar;
   import net.bigpoint.darkorbit.fui.components.text.label.Label;
   import net.bigpoint.darkorbit.fui.system.utils.BindingsUtils;
   import net.bigpoint.darkorbit.fui.system.utils.FuiComponentSelectorUtil;
   import net.bigpoint.darkorbit.gui.windows.simpleWindow.SimpleWindow;
   import net.bigpoint.darkorbit.gui.windows.simpleWindow.SimpleWindowEvent;
   import net.bigpoint.darkorbit.mvc.abstract.view.DOAbstractMediator;
   import net.bigpoint.darkorbit.mvc.dominationWindow.DominationNotificationNames;
   import net.bigpoint.darkorbit.mvc.dominationWindow.DominationWindowConstants;
   import net.bigpoint.darkorbit.mvc.dominationWindow.model.vo.DominationWindowModel;
   import net.bigpoint.darkorbit.mvc.dominationWindow.view.components.DominationItemDataAssigner;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class DominationWindowMediator extends DOAbstractMediator
   {
      
      public static const NAME:String = "DominationWindowMediator";
      
      private var _contentContainer:Sprite;
      
      private var _itemList:ItemList;
      
      private var _mmoDomiationScore:Label;
      
      private var _eicDomiationScore:Label;
      
      private var _vruDomiationScore:Label;
      
      public function DominationWindowMediator(param1:SimpleWindow)
      {
         super(NAME,param1);
         param1.setSize(274,320);
         this.assignComponents();
         this.addListeners();
         mapNotificationToMethod(DominationNotificationNames.UPDATE_VIEW,this.update);
      }
      
      private function addListeners() : void
      {
         this.window.addEventListener(SimpleWindowEvent.ON_CLOSE,this.handleWindowClosed);
      }
      
      private function assignComponents() : void
      {
         this._contentContainer = this.window.getRootContainer().getChildByName(DominationWindowConstants.WINDOW_CONTENT_CONTAINER) as Sprite;
         this._itemList = this._contentContainer.getChildByName(DominationWindowConstants.ITEMLIST) as ItemList;
         this._itemList.itemDataAssigner = DominationItemDataAssigner;
         var _loc1_:Sprite = this._contentContainer.getChildByName(DominationWindowConstants.INFO_CONTAINER) as Sprite;
         var _loc2_:ScrollContainer = _loc1_.getChildByName(DominationWindowConstants.SCROLL_CONTAINER) as ScrollContainer;
         var _loc3_:Scrollbar = _loc1_.getChildByName(DominationWindowConstants.SCROLL_BAR) as Scrollbar;
         BindingsUtils.bindScrollComponents(_loc2_,_loc3_);
         var _loc4_:Container = _loc2_.getChildByName(DominationWindowConstants.CONTENT_CONTAINER) as Container;
         var _loc5_:Label = _loc4_.getChildByName(DominationWindowConstants.CONTENT_LABEL) as Label;
         _loc5_.text = DominationWindowConstants.INFO_MESSAGE;
         var _loc6_:Coreponent = FuiComponentSelectorUtil.selectComponent("statusContainer.mmoStatusContainer.company_img",this._contentContainer) as Coreponent;
         var _loc7_:Coreponent = FuiComponentSelectorUtil.selectComponent("statusContainer.eicStatusContainer.company_img",this._contentContainer) as Coreponent;
         var _loc8_:Coreponent = FuiComponentSelectorUtil.selectComponent("statusContainer.vruStatusContainer.company_img",this._contentContainer) as Coreponent;
         _loc6_.setSkinState("mmo");
         _loc7_.setSkinState("eic");
         _loc8_.setSkinState("vru");
         this._mmoDomiationScore = FuiComponentSelectorUtil.selectComponent("statusContainer.mmoStatusContainer.score",this._contentContainer) as Label;
         this._eicDomiationScore = FuiComponentSelectorUtil.selectComponent("statusContainer.eicStatusContainer.score",this._contentContainer) as Label;
         this._vruDomiationScore = FuiComponentSelectorUtil.selectComponent("statusContainer.vruStatusContainer.score",this._contentContainer) as Label;
      }
      
      private function update(param1:INotification) : void
      {
         var _loc2_:DominationWindowModel = param1.getBody() as DominationWindowModel;
         this._itemList.list = new VectorCollection(_loc2_.list);
         this.setScore(this._mmoDomiationScore,_loc2_.dominationPoints.mmo);
         this.setScore(this._eicDomiationScore,_loc2_.dominationPoints.eic);
         this.setScore(this._vruDomiationScore,_loc2_.dominationPoints.vru);
      }
      
      private function setScore(param1:Label, param2:int) : void
      {
         param1.text = param2.toString();
         var _loc3_:Boolean = param2 >= DominationWindowConstants.MIN_DOMINTAION_SCORE;
         param1.registeredTextStyleName = _loc3_ ? DominationWindowConstants.DOMINTAION_TEXT_STYLE : DominationWindowConstants.NOT_DOMINTAION_TEXT_STYLE;
         param1.filters = _loc3_ ? DominationWindowConstants.DOMINATION_FILTER : DominationWindowConstants.NOT_DOMINATION_FILTER;
      }
      
      private function get window() : SimpleWindow
      {
         return getViewComponent() as SimpleWindow;
      }
      
      private function handleWindowClosed(param1:SimpleWindowEvent) : void
      {
         facade.removeMediator(this.getMediatorName());
      }
      
      override public function onRemove() : void
      {
         this.removeListeners();
         sendNotification(DominationNotificationNames.CLEANUP);
         super.onRemove();
      }
      
      private function removeListeners() : void
      {
         var _loc1_:Sprite = this._contentContainer.getChildByName(DominationWindowConstants.INFO_CONTAINER) as Sprite;
         var _loc2_:ScrollContainer = _loc1_.getChildByName(DominationWindowConstants.SCROLL_CONTAINER) as ScrollContainer;
         var _loc3_:Scrollbar = _loc1_.getChildByName(DominationWindowConstants.SCROLL_BAR) as Scrollbar;
         BindingsUtils.unbindScrollComponents(_loc2_,_loc3_);
         this.window.removeEventListener(SimpleWindowEvent.ON_CLOSE,this.handleWindowClosed);
      }
   }
}

