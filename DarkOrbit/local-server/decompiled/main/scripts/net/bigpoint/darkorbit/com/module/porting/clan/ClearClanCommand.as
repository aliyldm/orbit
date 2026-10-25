package net.bigpoint.darkorbit.com.module.porting.clan
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class ClearClanCommand implements IModule
   {
      
      private static var _instance:ClearClanCommand;
      
      public var clanId:int = 0;
      
      public function ClearClanCommand(param1:int = 0)
      {
         super();
         this.clanId = param1;
      }
      
      public static function get instance() : ClearClanCommand
      {
         return _instance || (_instance = new ClearClanCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return -29914;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 4;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.clanId = param1.readInt();
         this.clanId = this.clanId >>> 2 % 32 | this.clanId << 32 - 2 % 32;
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(-29914);
         param1.writeInt(this.clanId << 2 % 32 | this.clanId >>> 32 - 2 % 32);
      }
   }
}

