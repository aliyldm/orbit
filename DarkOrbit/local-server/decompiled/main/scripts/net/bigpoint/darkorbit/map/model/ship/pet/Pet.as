package net.bigpoint.darkorbit.map.model.ship.pet
{
   import net.bigpoint.darkorbit.Hero;
   import net.bigpoint.darkorbit.map.model.minimap.traits.AbstractMiniMapTrait;
   import net.bigpoint.darkorbit.map.model.minimap.traits.MiniMapIconTrait;
   import net.bigpoint.darkorbit.map.model.ship.Ship;
   import net.bigpoint.darkorbit.map.model.ship.factory.MinimapStrategyFactory;
   import net.bigpoint.darkorbit.map.model.ship.patterns.ShipPattern;
   import net.bigpoint.darkorbit.map.model.traits.PetMoveTrait;
   
   public class Pet extends Ship
   {
      
      public var idleState:Boolean = false;
      
      private var petTrait:PetTrait = new PetTrait();
      
      public function Pet(param1:int, param2:ShipPattern, param3:int, param4:int, param5:int)
      {
         super(param1,param2,param3 == Hero.userID ? new MiniMapIconTrait("mapIcon_pet","minimap",-1) : MinimapStrategyFactory.instance.build(param5));
         this.petTrait.ownerID.value = param3;
         this.petTrait.level.value = param4;
         addTrait(this.petTrait);
      }
      
      public function get level() : int
      {
         return this.petTrait.level.value;
      }
      
      public function set level(param1:int) : void
      {
         var _loc2_:int = this.petTrait.level.value;
         this.petTrait.level.value = param1;
         updateDisplay();
         this.updatePetLevelDisplay(_loc2_,param1);
      }
      
      override public function setMoveTrait() : void
      {
         addTrait(new PetMoveTrait());
      }
      
      override protected function updateVisibility() : void
      {
         if(this.isHeroPet() == false)
         {
            super.updateVisibility();
         }
      }
      
      override protected function addDisplayDecorators(param1:Vector.<Object>) : void
      {
         super.addDisplayDecorators(param1);
         if(this.isHeroPet())
         {
            param1.push({"id":"heroPet"});
         }
      }
      
      public function get ownerID() : int
      {
         return this.petTrait.ownerID.value;
      }
      
      private function updatePetLevelDisplay(param1:int, param2:int) : void
      {
         var _loc3_:String = "[" + param1 + "]";
         var _loc4_:String = "[" + param2 + "]";
         var _loc5_:String = info.username.value;
         var _loc6_:String = _loc5_.substr(0,_loc5_.lastIndexOf(_loc3_));
         var _loc7_:String = _loc5_.substr(_loc5_.lastIndexOf(_loc3_) + _loc3_.length,_loc5_.length);
         info.username.value = _loc6_ + _loc4_ + _loc7_;
      }
      
      public function isHeroPet() : Boolean
      {
         return this.petTrait.ownerID.value == Hero.userID;
      }
      
      public function get evasionProtocolEquiped() : Boolean
      {
         return this.petTrait.evasionProtocolEquiped.value;
      }
      
      public function set evasionProtocolEquiped(param1:Boolean) : void
      {
         this.petTrait.evasionProtocolEquiped.value = param1;
      }
   }
}

