package net.bigpoint.darkorbit.mvc.gui.windows.expedition.view.tab.itemRenderer
{
   import flash.display.DisplayObjectContainer;
   import net.bigpoint.darkorbit.fui.UISystem;
   import net.bigpoint.darkorbit.fui.components.core.Coreponent;
   import net.bigpoint.darkorbit.fui.components.core.InvalidationType;
   import net.bigpoint.darkorbit.fui.components.core.data.VectorCollection;
   import net.bigpoint.darkorbit.fui.components.scroll.ScrollContainer;
   import net.bigpoint.darkorbit.fui.components.scroll.Scrollbar;
   import net.bigpoint.darkorbit.fui.system.utils.BindingsUtils;
   
   public class Tab3ItemList
   {
      
      private var _view:ScrollContainer;
      
      private var _scrollBar:Scrollbar;
      
      private var itemXML:XML = <coreponent name="reward_list_item" width="825" autoSizeWidth="false" autoSizeHeight="false" mouseEnabled="true" mouseChildren="true">
                <coreponent name="item_bg" width="825" height="20" registeredSkinName="expendition_tab3_itemRenderer_bg"/>
                <Label name="rank_label" width="120" height="20" alignY="top" alignX="left" registeredTextStyleName="expendition_tab3_list_item_rank_label" registeredSkinName="commonui_default_label"/>
                <itemlist name="item_reward_list" width="700" autoSizeWidth="false" autoSizeHeight="false" alignY="top" marginTop="10" alignX="left" marginLeft="125" alignmentX="left" itemAlignX="left" itemAlignY="top" itemGap="1" cacheSkinMaskAsBitmap="false" direction="vertical" layout="grid" registeredSkinName="commonui_list_mask">
                    <itemrenderer width="230" height="50" autoSizeWidth="false" autoSizeHeight="false" mouseEnabled="true" mouseChildren="true">
                        <coreponent name="icon_bg" alignY="center" alignX="left" width="50" height="50" registeredSkinName="expendition_tab3_item_icon_bg"/>
                        <coreponent name="icon" alignY="center" alignX="left" width="50" height="50"/>
                        <Label name="item_count" width="150" height="20" alignY="center" alignX="left" marginLeft="55" registeredTextStyleName="expendition_tab3_list_item_label" registeredSkinName="commonui_default_label"/>

                    </itemrenderer>

                </itemlist>
            </coreponent>;
      
      public function Tab3ItemList(param1:ScrollContainer, param2:Scrollbar, param3:Object)
      {
         super();
         this._view = param1;
         this._scrollBar = param2;
      }
      
      public function setData(param1:VectorCollection) : void
      {
         var _loc4_:Tab3ListItemRenderer = null;
         var _loc2_:Number = 0;
         (this._view.content as Coreponent).removeChildren();
         var _loc3_:int = 0;
         while(_loc3_ < param1.length)
         {
            _loc4_ = this.getItem();
            _loc4_.data = param1.getItemAt(_loc3_);
            _loc4_.y = _loc2_;
            _loc4_.forceRedraw(InvalidationType.POSITION);
            (this._view.content as Coreponent).addChild(_loc4_);
            _loc2_ += _loc4_.__height + 5;
            _loc3_++;
         }
         this._view.forceRedraw(InvalidationType.SIZE,true);
         BindingsUtils.bindScrollComponents(this._view,this._scrollBar);
      }
      
      private function getItem() : Tab3ListItemRenderer
      {
         var _loc1_:Coreponent = new Tab3ListItemRenderer() as Coreponent;
         var _loc2_:DisplayObjectContainer = _loc1_ as DisplayObjectContainer;
         UISystem.getInstance().build(this.itemXML,_loc2_,true);
         return _loc1_ as Tab3ListItemRenderer;
      }
   }
}

