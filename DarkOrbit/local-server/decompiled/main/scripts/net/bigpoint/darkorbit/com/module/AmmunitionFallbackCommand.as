package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class AmmunitionFallbackCommand implements IModule
   {
      
      private static var _instance:AmmunitionFallbackCommand;
      
      public static const AMMUNITIONTYPE_LASER:int = 0;
      
      public static const AMMUNITIONTYPE_ROCKET:int = 1;
      
      public static const AMMUNITIONTYPE_MINES:int = 2;
      
      public static const AMMUNITIONTYPE__MAX:int = 3;
      
      public var ammunitionType:int = 0;
      
      public var typeIdOld:int = 0;
      
      public var typeIdNew:int = 0;
      
      public function AmmunitionFallbackCommand(param1:int = 0, param2:int = 0, param3:int = 0)
      {
         super();
         this.ammunitionType = param1;
         this.typeIdOld = param2;
         this.typeIdNew = param3;
      }
      
      public static function get instance() : AmmunitionFallbackCommand
      {
         return _instance || (_instance = new AmmunitionFallbackCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 13;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 8;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.ammunitionType = param1.readShort();
         this.typeIdOld = param1.readInt();
         this.typeIdOld = this.typeIdOld << 10 % 32 | this.typeIdOld >>> 32 - 10 % 32;
         this.typeIdNew = param1.readInt();
         this.typeIdNew = this.typeIdNew >>> 16 % 32 | this.typeIdNew << 32 - 16 % 32;
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(13);
         param1.writeShort(this.ammunitionType);
         param1.writeInt(this.typeIdOld >>> 10 % 32 | this.typeIdOld << 32 - 10 % 32);
         param1.writeInt(this.typeIdNew << 16 % 32 | this.typeIdNew >>> 32 - 16 % 32);
      }
   }
}

