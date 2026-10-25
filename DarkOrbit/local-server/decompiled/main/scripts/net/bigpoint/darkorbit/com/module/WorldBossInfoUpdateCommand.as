package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class WorldBossInfoUpdateCommand implements IModule
   {
      
      private static var _instance:WorldBossInfoUpdateCommand;
      
      public var currHealth:Number = 0;
      
      public var maxHealth:Number = 0;
      
      public var currTier:int = 0;
      
      public function WorldBossInfoUpdateCommand(param1:Number = 0, param2:Number = 0, param3:int = 0)
      {
         super();
         this.currHealth = param1;
         this.maxHealth = param2;
         this.currTier = param3;
      }
      
      public static function get instance() : WorldBossInfoUpdateCommand
      {
         return _instance || (_instance = new WorldBossInfoUpdateCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 26573;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 20;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.currHealth = param1.readDouble();
         this.maxHealth = param1.readDouble();
         this.currTier = param1.readInt();
         this.currTier = this.currTier >>> 6 % 32 | this.currTier << 32 - 6 % 32;
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(26573);
         param1.writeDouble(this.currHealth);
         param1.writeDouble(this.maxHealth);
         param1.writeInt(this.currTier << 6 % 32 | this.currTier >>> 32 - 6 % 32);
      }
   }
}

