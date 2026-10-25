package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class RankModule implements IModule
   {
      
      private static var _instance:RankModule;
      
      public var lastUpdateTime:Number = 0;
      
      public var name:String = "";
      
      public var rank:int = 0;
      
      public var points:int = 0;
      
      public function RankModule(param1:int = 0, param2:String = "", param3:Number = 0, param4:int = 0)
      {
         super();
         this.lastUpdateTime = param3;
         this.name = param2;
         this.rank = param1;
         this.points = param4;
      }
      
      public static function get instance() : RankModule
      {
         return _instance || (_instance = new RankModule());
      }
      
      public function getLibcomModuleId() : int
      {
         return 18647;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 18;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.lastUpdateTime = param1.readDouble();
         this.name = param1.readUTF();
         this.rank = param1.readInt();
         this.rank = this.rank << 1 % 32 | this.rank >>> 32 - 1 % 32;
         this.points = param1.readInt();
         this.points = this.points >>> 10 % 32 | this.points << 32 - 10 % 32;
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(18647);
         param1.writeDouble(this.lastUpdateTime);
         param1.writeUTF(this.name);
         param1.writeInt(this.rank >>> 1 % 32 | this.rank << 32 - 1 % 32);
         param1.writeInt(this.points << 10 % 32 | this.points >>> 32 - 10 % 32);
      }
   }
}

