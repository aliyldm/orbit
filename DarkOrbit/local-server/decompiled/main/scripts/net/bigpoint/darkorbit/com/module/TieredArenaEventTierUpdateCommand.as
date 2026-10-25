package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class TieredArenaEventTierUpdateCommand implements IModule
   {
      
      private static var _instance:TieredArenaEventTierUpdateCommand;
      
      public static const PLAYERTIER_UNKNOWN:int = 0;
      
      public static const PLAYERTIER_LOW:int = 1;
      
      public static const PLAYERTIER_HIGH:int = 2;
      
      public static const PLAYERTIER__MAX:int = 3;
      
      public var playerTier:int = 0;
      
      public function TieredArenaEventTierUpdateCommand(param1:int = 0)
      {
         super();
         this.playerTier = param1;
      }
      
      public static function get instance() : TieredArenaEventTierUpdateCommand
      {
         return _instance || (_instance = new TieredArenaEventTierUpdateCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return -7443;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 0;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.playerTier = param1.readShort();
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(-7443);
         param1.writeShort(this.playerTier);
      }
   }
}

