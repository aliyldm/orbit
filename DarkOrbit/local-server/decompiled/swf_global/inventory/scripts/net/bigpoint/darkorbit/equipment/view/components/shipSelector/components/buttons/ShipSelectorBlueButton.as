package net.bigpoint.darkorbit.equipment.view.components.shipSelector.components.buttons
{
   import com.greensock.TweenMax;
   import flash.text.TextFormat;
   
   public class ShipSelectorBlueButton extends AbstractShipSelectorButton
   {
      
      private var skinNormal:Class = ShipSelectorBlueButton_skinNormal;
      
      private var skinOver:Class = ShipSelectorBlueButton_skinOver;
      
      private var skinActive:Class = ShipSelectorBlueButton_skinActive;
      
      public function ShipSelectorBlueButton(param1:String = null, param2:TextFormat = null)
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

