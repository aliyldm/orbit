package net.bigpoint.darkorbit.equipment.view.components.shipSelector.components.buttons
{
   import com.greensock.TweenMax;
   import flash.text.TextFormat;
   
   public class ShipSelectorGreenButton extends AbstractShipSelectorButton
   {
      
      private var skinNormal:Class = ShipSelectorGreenButton_skinNormal;
      
      private var skinOver:Class = ShipSelectorGreenButton_skinOver;
      
      private var skinActive:Class = ShipSelectorGreenButton_skinActive;
      
      public function ShipSelectorGreenButton(param1:String = null, param2:TextFormat = null)
      {
         super(param1,param2);
      }
      
      override public function setEnable(param1:Boolean) : void
      {
         this.mouseChildren = this.mouseEnabled = param1;
         if(param1)
         {
            TweenMax.to(this,0.3,{"colorMatrixFilter":{
               "amount":1,
               "contrast":1,
               "brightness":1,
               "saturation":1
            }});
         }
         else
         {
            TweenMax.to(this,0.3,{"colorMatrixFilter":{
               "amount":1,
               "contrast":0.8,
               "brightness":0.8,
               "saturation":0
            }});
         }
      }
      
      override protected function createActiveState() : void
      {
         _active = new this.skinActive();
         super.createActiveState();
      }
      
      override protected function createOverState() : void
      {
         _over = new this.skinOver();
         super.createOverState();
      }
      
      override protected function createNormalState() : void
      {
         _normal = new this.skinNormal();
         super.createNormalState();
      }
   }
}

