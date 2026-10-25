package net.bigpoint.darkorbit.map.hud.ship
{
   import flash.events.Event;
   import net.bigpoint.darkorbit.gui.windows.components.LifeCounterComponent;
   import net.bigpoint.darkorbit.map.model.traits.hud.ScoremageddonIconTrait;
   
   public class ScoremageddonIconView extends AbstractIconView
   {
      
      private var _trait:ScoremageddonIconTrait;
      
      private var _livesLeftComponent:LifeCounterComponent;
      
      public function ScoremageddonIconView(param1:ScoremageddonIconTrait)
      {
         super();
         this._trait = param1;
         this._livesLeftComponent = new LifeCounterComponent(true);
         this._livesLeftComponent.y = -5;
         this._livesLeftComponent.maxDisplayWidth = 200;
         addChild(this._livesLeftComponent);
         this.update();
         addEventListener(Event.ADDED_TO_STAGE,this.handleAdded);
         addEventListener(Event.REMOVED_FROM_STAGE,this.handleRemoved);
      }
      
      private function handleRemoved(param1:Event) : void
      {
         this._trait.livesLeft.changed.remove(this.update);
         this._trait.livesMax.changed.remove(this.update);
         this._trait.combo.changed.remove(this.update);
         this._trait.comboMax.changed.remove(this.update);
      }
      
      private function handleAdded(param1:Event) : void
      {
         this._trait.livesLeft.changed.add(this.update);
         this._trait.livesMax.changed.add(this.update);
         this._trait.combo.changed.add(this.update);
         this._trait.comboMax.changed.add(this.update);
      }
      
      private function update() : void
      {
         this._livesLeftComponent.setComboValues(this._trait.combo.value - 1,this._trait.comboMax.value - 1);
         this._livesLeftComponent.setRemainingLives(this._trait.livesLeft.value,this._trait.livesMax.value);
         sizeChanged.dispatch();
      }
   }
}

