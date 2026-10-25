package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class AmmunitionEmptyCommand implements IModule
   {
      
      private static var _instance:AmmunitionEmptyCommand;
      
      public static const AMMUNITIONTYPE_LASER:int = 0;
      
      public static const AMMUNITIONTYPE_ROCKET:int = 1;
      
      public static const AMMUNITIONTYPE_MINES:int = 2;
      
      public static const AMMUNITIONTYPE__MAX:int = 3;
      
      public var ammunitionType:int = 0;
      
      public var alternativeAvailable:Boolean = false;
      
      public function AmmunitionEmptyCommand(param1:int = 0, param2:Boolean = false)
      {
         super();
         this.ammunitionType = param1;
         this.alternativeAvailable = param2;
      }
      
      public static function get instance() : AmmunitionEmptyCommand
      {
         return _instance || (_instance = new AmmunitionEmptyCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 12;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 1;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.ammunitionType = param1.readShort();
         this.alternativeAvailable = param1.readBoolean();
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(12);
         param1.writeShort(this.ammunitionType);
         param1.writeBoolean(this.alternativeAvailable);
      }
   }
}

