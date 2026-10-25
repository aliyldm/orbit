package net.bigpoint.darkorbit.mvc.targetedOffersWindow.view
{
   import com.bigpoint.utils.PointLite;
   import com.greensock.TweenLite;
   import flash.events.MouseEvent;
   import net.bigpoint.as3toolbox.filecollection.finish.SWFFinisher;
   import net.bigpoint.darkorbit.com.module.AlignmentModule;
   import net.bigpoint.darkorbit.gui.GuiManager;
   import net.bigpoint.darkorbit.gui.windows.simpleWindow.SimpleWindow;
   import net.bigpoint.darkorbit.managers.ResourceManager;
   import net.bigpoint.darkorbit.managers.ScreenManager;
   import net.bigpoint.darkorbit.mvc.common.utils.ScreenScaleUtils;
   import net.bigpoint.darkorbit.mvc.gui.GuiConstants;
   import net.bigpoint.darkorbit.mvc.gui.featuresMenu.model.vo.FeatureWindowVO;
   import net.bigpoint.darkorbit.mvc.targetedOffersWindow.controller.TargetedOfferEvent;
   
   public class TargetedOfferWindow extends SimpleWindow
   {
      
      private const Y_OFFSET:Number = 25;
      
      private const X_OFFSET:Number = 4.5;
      
      private var _offer:TargetedOffer;
      
      private var _alignment:uint;
      
      private var _startX:Number;
      
      private var _startY:Number;
      
      private var _targetX:Number;
      
      private var _targetY:Number;
      
      public function TargetedOfferWindow(param1:GuiManager, param2:FeatureWindowVO, param3:TargetedOffer, param4:uint)
      {
         super();
         preinitialize(param2,param1,SWFFinisher(ResourceManager.fileCollection.getFinisher("window")));
         this.alpha = 0;
         this._alignment = param4;
         this._offer = param3;
         _closeBtn.addEventListener(MouseEvent.CLICK,this.closeButtonHandler);
         setTitle("",false);
         setSize(param2.size.x,param2.size.y);
         addChild(param3);
         param3.x = this.X_OFFSET;
         param3.y = this.Y_OFFSET;
         this.initAlignment();
         ScreenManager.getInstance().getWindowLayer2().addChild(this);
         param1.addWindow(GuiConstants.TARGETED_OFFERS_WINDOW,this);
      }
      
      public function show() : void
      {
         this.alpha = 1;
         TweenLite.to(this,1,{
            "x":this._targetX,
            "y":this._targetY
         });
      }
      
      public function initAlignment() : void
      {
         var _loc3_:PointLite = null;
         var _loc1_:int = _size.x;
         var _loc2_:int = _size.y;
         switch(this._alignment)
         {
            case AlignmentModule.ALIGNMENT_NORTH:
               this._startX = ScreenManager.getHalfScreenWidth() - _loc1_ / 2;
               this._startY = -_loc2_ - 35;
               this._targetX = ScreenManager.getHalfScreenWidth() - _loc1_ / 2;
               this._targetY = 70;
               break;
            case AlignmentModule.ALIGNMENT_NORT_EAST:
               this._startX = ScreenManager.getScreenWidth() + 10;
               this._startY = 70;
               this._targetX = ScreenManager.getScreenWidth() - _loc1_ - 30;
               this._targetY = 70;
               break;
            case AlignmentModule.ALIGNMENT_EAST:
               this._startX = ScreenManager.getScreenWidth() + 10;
               this._startY = ScreenManager.getHalfScreenHeight() - _loc2_ / 2;
               this._targetX = ScreenManager.getScreenWidth() - _loc1_ - 30;
               this._targetY = ScreenManager.getHalfScreenHeight() - _loc2_ / 2;
               break;
            case AlignmentModule.ALIGNMENT_SOUTH_EAST:
               this._startX = ScreenManager.getScreenWidth() + 10;
               this._startY = ScreenManager.getScreenHeight() - _loc2_ - 30;
               this._targetX = ScreenManager.getScreenWidth() - _loc1_ - 30;
               this._targetY = ScreenManager.getScreenHeight() - _loc2_ - 30;
               break;
            case AlignmentModule.ALIGNMENT_SOUTH:
               this._startX = ScreenManager.getHalfScreenWidth() - _loc1_ / 2;
               this._startY = ScreenManager.getScreenHeight() - 10;
               this._targetX = ScreenManager.getHalfScreenWidth() - _loc1_ / 2;
               this._targetY = ScreenManager.getScreenHeight() - _loc2_ - 30;
               break;
            case AlignmentModule.ALIGNMENT_SOUTH_WEST:
               this._startX = -_loc1_ - 10;
               this._startY = ScreenManager.getScreenHeight() - _loc2_ + 30;
               this._targetX = 5;
               this._targetY = ScreenManager.getScreenHeight() - _loc2_ - 35;
               break;
            case AlignmentModule.ALIGNMENT_WEST:
               this._startX = -_loc1_ - 10;
               this._startY = ScreenManager.getHalfScreenHeight() - _loc2_ / 2;
               this._targetX = ScreenManager.getScreenWidth() * 0.02;
               this._targetY = ScreenManager.getHalfScreenHeight() - _loc2_ / 2;
               break;
            case AlignmentModule.ALIGNMENT_NORTH_WEST:
               this._startX = -_loc1_ - 10;
               this._startY = 70;
               this._targetX = 5;
               this._targetY = 70;
               break;
            case AlignmentModule.ALIGNMENT_CENTER:
               this._startX = ScreenManager.getHalfScreenWidth() - _loc1_ / 2;
               this._startY = -_loc2_ - 50;
               this._targetX = ScreenManager.getHalfScreenWidth() - _loc1_ / 2;
               this._targetY = ScreenManager.getHalfScreenHeight() - _loc2_ / 2 + 50;
               break;
            default:
               _loc3_ = ScreenScaleUtils.getRealPosFromPercentagePos(ScreenManager.getInstance().stageSize,size,_positionPercentage);
               this._startX = this._targetX = _loc3_.x;
               this._startY = this._targetY = _loc3_.y;
         }
         this.x = this._startX;
         this.y = this._startY;
      }
      
      private function closeButtonHandler(param1:MouseEvent) : void
      {
         dispatchEvent(new TargetedOfferEvent(TargetedOfferEvent.OFFER_DECLINED));
      }
      
      public function get offer() : TargetedOffer
      {
         return this._offer;
      }
      
      public function get targetX() : Number
      {
         return this._targetX;
      }
      
      public function get targetY() : Number
      {
         return this._targetY;
      }
      
      public function get alignment() : uint
      {
         return this._alignment;
      }
   }
}

