package net.bigpoint.darkorbit.mvc.influenceWindow.view
{
   import com.bigpoint.utils.TextFormatter;
   import flash.filters.GlowFilter;
   import net.bigpoint.darkorbit.fui.components.core.Container;
   import net.bigpoint.darkorbit.fui.components.core.data.VectorCollection;
   import net.bigpoint.darkorbit.fui.components.list.itemlist.ItemList;
   import net.bigpoint.darkorbit.fui.components.scroll.ScrollContainer;
   import net.bigpoint.darkorbit.fui.components.scroll.Scrollbar;
   import net.bigpoint.darkorbit.fui.components.text.label.Label;
   import net.bigpoint.darkorbit.fui.system.utils.BindingsUtils;
   import net.bigpoint.darkorbit.gui.windows.simpleWindow.SimpleWindow;
   import net.bigpoint.darkorbit.gui.windows.simpleWindow.SimpleWindowEvent;
   import net.bigpoint.darkorbit.mvc.abstract.view.DOAbstractMediator;
   import net.bigpoint.darkorbit.mvc.influenceWindow.InfluenceWindowConsts;
   import net.bigpoint.darkorbit.mvc.influenceWindow.InfluenceWindowNotifications;
   import net.bigpoint.darkorbit.mvc.influenceWindow.model.InfluenceModel;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class InfluenceWindowMediator extends DOAbstractMediator
   {
      
      public static const NAME:String = "InfluenceWindowMediator";
      
      private static const FILTER:Array = [new GlowFilter(4520959,1,5,5,2)];
      
      private var _window:SimpleWindow;
      
      public function InfluenceWindowMediator(param1:Object, param2:SimpleWindow)
      {
         super(NAME,param1);
         this._window = param2;
         this.addListeners();
         mapNotificationToMethod(InfluenceWindowNotifications.UPDATE_PLAYER_INFLUENCE,this.updatePlayerInfluence);
         mapNotificationToMethod(InfluenceWindowNotifications.UPDATE_ALL,this.updateAll);
      }
      
      private function updateAll(param1:INotification) : void
      {
         var _loc2_:InfluenceModel = param1.getBody() as InfluenceModel;
         this.factionItemList.list = new VectorCollection(_loc2_.list);
         this.setPlayerScore(_loc2_.playerScore);
      }
      
      private function updatePlayerInfluence(param1:INotification) : void
      {
         this.setPlayerScore(param1.getBody() as Number);
      }
      
      private function setPlayerScore(param1:Number) : void
      {
         this.playerScoreLable.text = TextFormatter.round(param1);
      }
      
      private function get influenceWindow() : Container
      {
         return viewComponent as Container;
      }
      
      private function get factionItemList() : ItemList
      {
         return this.influenceWindow.getChildByName(InfluenceWindowConsts.INFLUENCE_ITEM_LIST_KEY) as ItemList;
      }
      
      private function get playerScoreLable() : Label
      {
         return this.influenceWindow.getChildByName(InfluenceWindowConsts.PLAYER_SCORE_LABEL_KEY) as Label;
      }
      
      private function addListeners() : void
      {
         this.addDataAsigner();
         this.decoratePlayerScore();
         this._window.addEventListener(SimpleWindowEvent.ON_CLOSE,this.handleWindowClosed);
         this.addScroller(InfluenceWindowConsts.COMPANY_INFO_CONTAINER_KEY,InfluenceWindowConsts.COMPANY_INFO_SCROLLBAR_KEY,InfluenceWindowConsts.COMPANY_INFO_SCROLLCONTAINER_KEY);
         this.addScroller(InfluenceWindowConsts.PLAYER_INFO_CONTAINER_KEY,InfluenceWindowConsts.PLAYER_INFO_SCROLLBAR_KEY,InfluenceWindowConsts.PLAYER_INFO_SCROLLCONTAINER_KEY);
      }
      
      private function handleWindowClosed(param1:SimpleWindowEvent) : void
      {
         facade.removeMediator(this.getMediatorName());
      }
      
      override public function onRemove() : void
      {
         this.removeListeners();
         sendNotification(InfluenceWindowNotifications.CLEANUP);
         super.onRemove();
      }
      
      private function removeListeners() : void
      {
         this._window.removeEventListener(SimpleWindowEvent.ON_CLOSE,this.handleWindowClosed);
         this.removeScroller(InfluenceWindowConsts.COMPANY_INFO_CONTAINER_KEY,InfluenceWindowConsts.COMPANY_INFO_SCROLLBAR_KEY,InfluenceWindowConsts.COMPANY_INFO_SCROLLCONTAINER_KEY);
         this.removeScroller(InfluenceWindowConsts.PLAYER_INFO_CONTAINER_KEY,InfluenceWindowConsts.PLAYER_INFO_SCROLLBAR_KEY,InfluenceWindowConsts.PLAYER_INFO_SCROLLCONTAINER_KEY);
      }
      
      private function addDataAsigner() : void
      {
         this.factionItemList.itemDataAssigner = InfluenceItemDataAsigner;
      }
      
      private function decoratePlayerScore() : void
      {
         this.playerScoreLable.filters = FILTER;
      }
      
      private function addScroller(param1:String, param2:String, param3:String) : void
      {
         var _loc4_:Container = this.influenceWindow.getChildByName(param1) as Container;
         var _loc5_:Scrollbar = _loc4_.getChildByName(param2) as Scrollbar;
         var _loc6_:ScrollContainer = _loc4_.getChildByName(param3) as ScrollContainer;
         BindingsUtils.bindScrollComponents(_loc6_,_loc5_);
      }
      
      private function removeScroller(param1:String, param2:String, param3:String) : void
      {
         var _loc4_:Container = this.influenceWindow.getChildByName(param1) as Container;
         var _loc5_:Scrollbar = _loc4_.getChildByName(param2) as Scrollbar;
         var _loc6_:ScrollContainer = _loc4_.getChildByName(param3) as ScrollContainer;
         BindingsUtils.unbindScrollComponents(_loc6_,_loc5_);
      }
   }
}

