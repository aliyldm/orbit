package net.bigpoint.darkorbit.mvc.gui.itemsControlMenu.view.components
{
   import com.bigpoint.utils.ui.lists.layoutedList.IListLayout;
   import com.bigpoint.utils.ui.lists.layoutedList.layouts.HorizontalListLayout;
   import com.bigpoint.utils.ui.lists.layoutedList.layouts.ProActionHorizontalGridLayout;
   import com.bigpoint.utils.ui.lists.layoutedList.layouts.ProActionVerticalGridLayout;
   import com.bigpoint.utils.ui.lists.layoutedList.layouts.VerticallListLayout;
   import com.greensock.TweenLite;
   import com.greensock.TweenMax;
   import com.greensock.easing.Expo;
   import flash.display.DisplayObject;
   import flash.geom.Point;
   import net.bigpoint.as3toolbox.filecollection.finish.SWFFinisher;
   import net.bigpoint.darkorbit.Hero;
   import net.bigpoint.darkorbit.mvc.application.GameFacade;
   import net.bigpoint.darkorbit.mvc.gui.itemsControlMenu.ItemsControlMenuConstants;
   import net.bigpoint.darkorbit.mvc.gui.itemsControlMenu.ItemsControlMenuNotifications;
   import net.bigpoint.darkorbit.mvc.gui.itemsControlMenu.model.vo.slotBar.SlotBarVO;
   import net.bigpoint.darkorbit.mvc.gui.itemsControlMenu.view.components.elements.slotAndItemElement.SlotAndItemBarElement;
   import net.bigpoint.darkorbit.mvc.gui.itemsControlMenu.view.components.menuBar.MenuBar;
   import net.bigpoint.darkorbit.mvc.gui.itemsControlMenu.view.components.menuBar.actionButtons.ProActionBarToggleButton;
   import net.bigpoint.darkorbit.settings.Settings;
   
   public class ProActionBar extends MenuBar
   {
      
      private static var _dragButtonBasePositionX:Number = -32;
      
      private static var _rotateButtonBasePositionX:Number = -10;
      
      public var proActionBarButton:ProActionBarToggleButton;
      
      private var _barVisibility:Boolean = true;
      
      public function ProActionBar(param1:SWFFinisher)
      {
         super(param1,true);
         this.proActionBarButton.visible = false;
      }
      
      override public function decorate() : void
      {
         super.decorate();
         addViewChild(this.proActionBarButton = new ProActionBarToggleButton(_swfFinisher));
         this.proActionBarButton.view.height = SlotAndItemBarElement.DEFAULT_SIZE * 0.9;
         this.proActionBarButton.view.width = SlotAndItemBarElement.DEFAULT_SIZE * 0.9;
         _dragButtonBasePositionX = dragButton.x;
         _rotateButtonBasePositionX = rotateButton.x;
      }
      
      override public function updateOnListLayoutChange(param1:Point, param2:Boolean = true) : void
      {
         if(!param2)
         {
            if(this._barVisibility)
            {
               this.show(true);
            }
            else
            {
               this.hide(true);
            }
         }
         else
         {
            super.updateOnListLayoutChange(param1,true);
         }
         this.setButtonPos();
      }
      
      override public function showItems(param1:Array, param2:int, param3:int = 50, param4:Boolean = false, param5:SlotBarVO = null, param6:IListLayout = null, param7:int = 0) : void
      {
         super.showItems(param1,param2,param3,param4,param5,param6);
         if(param5)
         {
            if(param5.id == ItemsControlMenuConstants.PRO_ACTION_BAR)
            {
               if(this._barVisibility != param5.isVisible)
               {
                  GameFacade.getInstance().sendNotification(ItemsControlMenuNotifications.TOGGLE_PRO_ACTION_BUTTON);
               }
            }
         }
      }
      
      private function setButtonPos() : void
      {
         if(this.proActionBarButton.alpha == 0)
         {
            TweenMax.to(this.proActionBarButton,0.5,{"alpha":0.5});
         }
         rotateButton.width = dragButton.width;
         dragButton.x = _dragButtonBasePositionX;
         rotateButton.x = _rotateButtonBasePositionX;
         var _loc1_:Point = new Point();
         switch(layoutedList.layout.id)
         {
            case ProActionHorizontalGridLayout.ID:
               _loc1_.x = 2 * SlotAndItemBarElement.DEFAULT_SIZE + this.proActionBarButton.view.width / 2 + SlotAndItemBarElement.DEFAULT_SIZE * 0.1 - 0.5;
               _loc1_.y = SlotAndItemBarElement.DEFAULT_SIZE + this.proActionBarButton.view.height / 2;
               break;
            case ProActionVerticalGridLayout.ID:
               _loc1_.x = SlotAndItemBarElement.DEFAULT_SIZE + this.proActionBarButton.view.width / 2 + SlotAndItemBarElement.DEFAULT_SIZE * 0.1 - 0.5;
               _loc1_.y = 2 * SlotAndItemBarElement.DEFAULT_SIZE + this.proActionBarButton.view.height / 2;
               break;
            case VerticallListLayout.ID:
               _loc1_.x = this.proActionBarButton.view.width / 2 + SlotAndItemBarElement.DEFAULT_SIZE * 0.1 - 0.5;
               _loc1_.y = -1 * SlotAndItemBarElement.DEFAULT_SIZE + this.proActionBarButton.view.height / 2;
               break;
            case HorizontalListLayout.ID:
               _loc1_.x = -1 * SlotAndItemBarElement.DEFAULT_SIZE + this.proActionBarButton.view.width / 2 + SlotAndItemBarElement.DEFAULT_SIZE * 0.1 - 0.5;
               _loc1_.y = this.proActionBarButton.view.height / 2;
               dragButton.x -= SlotAndItemBarElement.DEFAULT_SIZE;
               rotateButton.x -= SlotAndItemBarElement.DEFAULT_SIZE;
         }
         TweenMax.to(this.proActionBarButton.view,0.5,{
            "x":_loc1_.x,
            "y":_loc1_.y,
            "ease":Expo.easeOut
         });
      }
      
      private function show(param1:Boolean = false) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:DisplayObject = null;
         var _loc5_:int = 0;
         var _loc6_:Point = null;
         if(layoutedList.items)
         {
            _loc2_ = int(layoutedList.items.length);
            _loc3_ = 0;
            while(_loc3_ < _loc2_)
            {
               _loc4_ = layoutedList.items[_loc3_];
               _loc4_.x = this.proActionBarButton.view.x - this.proActionBarButton.view.width / 2 - SlotAndItemBarElement.DEFAULT_SIZE * 0.1 + 0.5;
               _loc4_.y = this.proActionBarButton.view.y - this.proActionBarButton.view.height / 2 - SlotAndItemBarElement.DEFAULT_SIZE * 0.1 + 0.5;
               _loc3_++;
            }
            TweenLite.to(this.proActionBarButton,0.5,{"alpha":0.8});
            _loc5_ = int(layoutedList.items.length);
            _loc3_ = 0;
            while(_loc3_ < _loc5_)
            {
               _loc4_ = layoutedList.items[_loc3_];
               _loc6_ = layoutedList.layout.getItemPosition(SlotAndItemBarElement.DEFAULT_SIZE,_loc3_);
               _loc4_.visible = true;
               TweenLite.to(_loc4_,param1 ? 0 : 0.5,{
                  "alpha":1,
                  "x":_loc6_.x,
                  "y":_loc6_.y,
                  "ease":Expo.easeOut
               });
               _loc3_++;
            }
         }
      }
      
      private function hide(param1:Boolean = false) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:DisplayObject = null;
         if(layoutedList.items)
         {
            TweenLite.to(this.proActionBarButton,0.5,{"alpha":0.5});
            _loc2_ = int(layoutedList.items.length);
            _loc3_ = 0;
            while(_loc3_ < _loc2_)
            {
               _loc4_ = layoutedList.items[_loc3_];
               TweenLite.to(_loc4_,param1 ? 0 : 0.5,{
                  "alpha":0,
                  "x":this.proActionBarButton.view.x - this.proActionBarButton.view.width / 2 - SlotAndItemBarElement.DEFAULT_SIZE * 0.1 + 0.5,
                  "y":this.proActionBarButton.view.y - this.proActionBarButton.view.height / 2,
                  "ease":Expo.easeOut,
                  "onComplete":this.turnOffVisibility,
                  "onCompleteParams":[_loc4_]
               });
               _loc3_++;
            }
         }
      }
      
      private function turnOffVisibility(param1:DisplayObject) : void
      {
         param1.visible = false;
      }
      
      public function set barVisibility(param1:Boolean) : void
      {
         this._barVisibility = param1;
         if(param1)
         {
            this.show(false);
         }
         else
         {
            this.hide(false);
         }
      }
      
      override public function get isAvailable() : Boolean
      {
         return Hero.premium.value && Settings.proActionBarEnabled.value;
      }
   }
}

