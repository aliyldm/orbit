package net.bigpoint.darkorbit.mvc.gui.featuresMenu.view.components
{
   import com.greensock.TweenMax;
   import flash.display.BitmapData;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import net.bigpoint.as3toolbox.filecollection.finish.SWFFinisher;
   import net.bigpoint.darkorbit.mvc.common.view.components.NotificationCountBadge;
   import net.bigpoint.darkorbit.mvc.gui.itemsControlMenu.view.components.elements.CategoryElement;
   
   public class FeatureBtn extends CategoryElement
   {
      
      private static const LINKAGE:String = "featureBtn";
      
      public static const MARGIN:int = 2;
      
      public static const FEATURE_BTN_CLICKED:String = "featureBtnClicked";
      
      public static const FEATURE_BTN_ROLLED_OVER:String = "featureBtnRolledOver";
      
      public static const FEATURE_BTN_ROLLED_OUT:String = "featureBtnRolledOut";
      
      private static const BADGE_MARGIN:Number = 2;
      
      private var _barId:String;
      
      private var _duringHighlight:Boolean;
      
      private var _notificationBadge:NotificationCountBadge;
      
      private var _badgeAnchorX:Number;
      
      public function FeatureBtn(param1:SWFFinisher, param2:String, param3:BitmapData, param4:BitmapData, param5:BitmapData)
      {
         super(param1,param2,param3,param4,param5);
      }
      
      override protected function clickHandler(param1:MouseEvent) : void
      {
         dispatchEvent(new Event(FEATURE_BTN_CLICKED,true));
      }
      
      override public function rollHandler(param1:MouseEvent) : void
      {
         super.rollHandler(param1);
         var _loc2_:String = param1.type == MouseEvent.ROLL_OVER ? FEATURE_BTN_ROLLED_OVER : FEATURE_BTN_ROLLED_OUT;
         dispatchEvent(new Event(_loc2_,true));
      }
      
      override public function get symbolLinkage() : String
      {
         return LINKAGE;
      }
      
      public function highlight(param1:Number) : void
      {
         if(!this._duringHighlight)
         {
            this._duringHighlight = true;
            this.doHighlight(param1);
         }
      }
      
      public function stopHighlight() : void
      {
         this._duringHighlight = false;
      }
      
      private function doHighlight(param1:Number) : void
      {
         if(this._duringHighlight)
         {
            TweenMax.to(this,param1,{
               "colorMatrixFilter":{
                  "brightness":1.5,
                  "contrast":1.5,
                  "saturation":1.5
               },
               "yoyo":true,
               "repeat":1,
               "onComplete":this.doHighlight,
               "onCompleteParams":[param1]
            });
         }
      }
      
      public function get barId() : String
      {
         return this._barId;
      }
      
      public function set barId(param1:String) : void
      {
         this._barId = param1;
      }
      
      public function setNotificationCount(param1:int, param2:Boolean = true) : void
      {
         if(!this._notificationBadge && param1 > 0)
         {
            this._badgeAnchorX = width > 0 ? width : 38;
            this._notificationBadge = new NotificationCountBadge();
            addViewChild(this._notificationBadge);
         }
         if(!this._notificationBadge)
         {
            return;
         }
         this._notificationBadge.showCount = param2;
         this._notificationBadge.count = param1;
         if(param2)
         {
            this._notificationBadge.x = this._badgeAnchorX - this._notificationBadge.width + 3;
            this._notificationBadge.y = -4;
         }
         else
         {
            this._notificationBadge.x = this._badgeAnchorX - this._notificationBadge.width - BADGE_MARGIN;
            this._notificationBadge.y = BADGE_MARGIN;
         }
         view.setChildIndex(this._notificationBadge,view.numChildren - 1);
      }
   }
}

