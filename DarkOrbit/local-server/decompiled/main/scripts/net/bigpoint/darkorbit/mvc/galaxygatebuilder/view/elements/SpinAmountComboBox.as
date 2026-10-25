package net.bigpoint.darkorbit.mvc.galaxygatebuilder.view.elements
{
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.as3toolbox.filecollection.finish.SWFFinisher;
   import net.bigpoint.darkorbit.mvc.application.GameFacade;
   import net.bigpoint.darkorbit.mvc.common.model.assets.AssetsProxy;
   import net.bigpoint.darkorbit.mvc.galaxygatebuilder.model.GalaxyGateBuilderModel;
   import net.bigpoint.darkorbit.mvc.galaxygatebuilder.view.events.SpinAmountEvent;
   
   public class SpinAmountComboBox extends Sprite
   {
      
      private var spinAmountBtn:MovieClip;
      
      private var spinAmountLabel:SpinAmountLabel;
      
      private var spinAmountList:SpinAmountList;
      
      public function SpinAmountComboBox()
      {
         var _loc3_:String = null;
         var _loc4_:int = 0;
         super();
         var _loc1_:AssetsProxy = GameFacade.getInstance().retrieveProxy(AssetsProxy.NAME) as AssetsProxy;
         var _loc2_:SWFFinisher = SWFFinisher(_loc1_.getLib("common"));
         this.spinAmountList = new SpinAmountList();
         this.spinAmountList.x = 26;
         this.spinAmountList.y = 21;
         addChild(this.spinAmountList);
         this.spinAmountLabel = new SpinAmountLabel();
         this.spinAmountLabel.x = 0;
         this.spinAmountLabel.y = 0;
         addChild(this.spinAmountLabel);
         this.spinAmountBtn = _loc2_.getEmbeddedMovieClip("spinAmount_btn");
         this.spinAmountBtn.buttonMode = true;
         this.spinAmountBtn.x = 0;
         this.spinAmountBtn.y = 7;
         addChild(this.spinAmountBtn);
         for each(_loc4_ in GalaxyGateBuilderModel.spinamounts)
         {
            if(_loc4_ > 1)
            {
               _loc3_ = BPLocale.getItemInCategory("galaxyGates","spinamount_p").replace(/%VALUE%/,_loc4_);
               this.spinAmountList.addItem(_loc4_,_loc3_);
            }
            else if(_loc4_ == 1)
            {
               _loc3_ = BPLocale.getItemInCategory("galaxyGates","spinamount_s");
               this.spinAmountLabel.text = _loc3_;
               this.spinAmountList.addItem(_loc4_,_loc3_);
            }
         }
         this.spinAmountList.addEventListener(SpinAmountEvent.ITEM_SELECT,this.handleSpinAmountSelect);
         this.enableButton();
      }
      
      private function handleSpinAmountSelect(param1:SpinAmountEvent) : void
      {
         this.spinAmountLabel.text = param1.text;
         dispatchEvent(new Event(Event.CHANGE));
      }
      
      private function enableButton() : void
      {
         this.spinAmountBtn.addEventListener(MouseEvent.CLICK,this.handleSpinAmountBtnClick);
         this.spinAmountBtn.addEventListener(MouseEvent.MOUSE_OVER,this.handleSpinAmountBtnMouseOver);
         this.spinAmountBtn.addEventListener(MouseEvent.MOUSE_OUT,this.handleSpinAmountBtnMouseOut);
         this.spinAmountBtn.gotoAndStop("std");
      }
      
      private function handleSpinAmountBtnClick(param1:MouseEvent) : void
      {
         this.spinAmountList.toggleVisibility();
      }
      
      private function handleSpinAmountBtnMouseOver(param1:MouseEvent) : void
      {
         this.spinAmountBtn.gotoAndStop("hover");
      }
      
      private function handleSpinAmountBtnMouseOut(param1:MouseEvent) : void
      {
         this.spinAmountBtn.gotoAndStop("std");
      }
      
      public function get selectedItem() : SpinAmountListItem
      {
         return this.spinAmountList.selectedItem;
      }
      
      public function setSelectedValue(param1:int) : void
      {
         this.spinAmountList.setSelectedValue(param1);
      }
   }
}

