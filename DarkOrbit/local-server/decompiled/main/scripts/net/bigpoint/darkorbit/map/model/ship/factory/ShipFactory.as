package net.bigpoint.darkorbit.map.model.ship.factory
{
   import flash.utils.Dictionary;
   import net.bigpoint.darkorbit.map.model.ship.factory.classes.AegisShipFactory;
   import net.bigpoint.darkorbit.map.model.ship.factory.classes.CitadelShipFactory;
   import net.bigpoint.darkorbit.map.model.ship.factory.classes.CubiconShipFactory;
   import net.bigpoint.darkorbit.map.model.ship.factory.classes.MiniMapCloakableShipFactory;
   import net.bigpoint.darkorbit.map.model.ship.factory.classes.MinionFactory;
   import net.bigpoint.darkorbit.map.model.ship.factory.classes.MotherShipFactory;
   import net.bigpoint.darkorbit.map.model.ship.factory.classes.NoMiniMapIconFactory;
   import net.bigpoint.darkorbit.map.model.ship.factory.classes.PoliceShipFactory;
   import net.bigpoint.darkorbit.map.model.ship.factory.classes.SimpleShipFactory;
   import net.bigpoint.darkorbit.map.model.ship.factory.classes.SolaceShipFactory;
   import net.bigpoint.darkorbit.map.model.ship.factory.classes.SpaceballFactory;
   import net.bigpoint.darkorbit.map.model.ship.factory.classes.StreunerTurretFactory;
   
   public class ShipFactory
   {
      
      public static const STANDART_CLASS:String = "standart";
      
      public static const STANDARD_CLASS:String = "standard";
      
      public static const SPACE_BALL:String = "spaceball";
      
      public static const MOTHERSHIP:String = "mothership";
      
      public static const MINION:String = "minion";
      
      public static const POLICE:String = "police";
      
      public static const SOLACE:String = "solace";
      
      public static const CITADEL:String = "citadel";
      
      public static const CUBICON:String = "cubicon";
      
      public static const AEGIS:String = "aegis";
      
      public static const STREUNER_TURRET:String = "streunerTurret";
      
      public static const PET:String = "pet";
      
      public static const MINIMAP_CLOAKABLE:String = "miniMapCloakable";
      
      public static const NO_MINIMAP_ICON:String = "noMiniMapIcon";
      
      private var _builderDic:Dictionary = new Dictionary();
      
      public function ShipFactory()
      {
         super();
         this._builderDic[STANDART_CLASS] = this._builderDic[STANDARD_CLASS] = new SimpleShipFactory();
         this._builderDic[SPACE_BALL] = new SpaceballFactory();
         this._builderDic[MOTHERSHIP] = new MotherShipFactory();
         this._builderDic[MINION] = new MinionFactory();
         this._builderDic[POLICE] = new PoliceShipFactory();
         this._builderDic[SOLACE] = new SolaceShipFactory();
         this._builderDic[AEGIS] = new AegisShipFactory();
         this._builderDic[CITADEL] = new CitadelShipFactory();
         this._builderDic[CUBICON] = new CubiconShipFactory();
         this._builderDic[STREUNER_TURRET] = new StreunerTurretFactory();
         this._builderDic[PET] = new SimpleShipFactory();
         this._builderDic[MINIMAP_CLOAKABLE] = new MiniMapCloakableShipFactory();
         this._builderDic[NO_MINIMAP_ICON] = new NoMiniMapIconFactory();
      }
      
      public function getBuilder(param1:String) : IShipFactory
      {
         return this._builderDic[param1];
      }
   }
}

