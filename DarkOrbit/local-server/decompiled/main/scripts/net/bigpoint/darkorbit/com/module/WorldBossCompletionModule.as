package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class WorldBossCompletionModule implements IModule
   {
      
      private static var _instance:WorldBossCompletionModule;
      
      public var completionFrom:int = 0;
      
      public var normalAmount:int = 0;
      
      public var easyAmount:int = 0;
      
      public var completionTo:int = 0;
      
      public var lootId:String = "";
      
      public function WorldBossCompletionModule(param1:String = "", param2:int = 0, param3:int = 0, param4:int = 0, param5:int = 0)
      {
         super();
         this.completionFrom = param2;
         this.normalAmount = param5;
         this.easyAmount = param4;
         this.completionTo = param3;
         this.lootId = param1;
      }
      
      public static function get instance() : WorldBossCompletionModule
      {
         return _instance || (_instance = new WorldBossCompletionModule());
      }
      
      public function getLibcomModuleId() : int
      {
         return 12806;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 18;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.completionFrom = param1.readInt();
         this.completionFrom = this.completionFrom >>> 16 % 32 | this.completionFrom << 32 - 16 % 32;
         this.normalAmount = param1.readInt();
         this.normalAmount = this.normalAmount >>> 11 % 32 | this.normalAmount << 32 - 11 % 32;
         this.easyAmount = param1.readInt();
         this.easyAmount = this.easyAmount << 13 % 32 | this.easyAmount >>> 32 - 13 % 32;
         this.completionTo = param1.readInt();
         this.completionTo = this.completionTo >>> 7 % 32 | this.completionTo << 32 - 7 % 32;
         this.lootId = param1.readUTF();
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(12806);
         param1.writeInt(this.completionFrom << 16 % 32 | this.completionFrom >>> 32 - 16 % 32);
         param1.writeInt(this.normalAmount << 11 % 32 | this.normalAmount >>> 32 - 11 % 32);
         param1.writeInt(this.easyAmount >>> 13 % 32 | this.easyAmount << 32 - 13 % 32);
         param1.writeInt(this.completionTo << 7 % 32 | this.completionTo >>> 32 - 7 % 32);
         param1.writeUTF(this.lootId);
      }
   }
}

