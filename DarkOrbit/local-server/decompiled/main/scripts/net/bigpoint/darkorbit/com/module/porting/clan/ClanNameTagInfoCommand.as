package net.bigpoint.darkorbit.com.module.porting.clan
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class ClanNameTagInfoCommand implements IModule
   {
      
      private static var _instance:ClanNameTagInfoCommand;
      
      public var tag:String = "";
      
      public var id:int = 0;
      
      public var name:String = "";
      
      public function ClanNameTagInfoCommand(param1:String = "", param2:String = "", param3:int = 0)
      {
         super();
         this.tag = param2;
         this.id = param3;
         this.name = param1;
      }
      
      public static function get instance() : ClanNameTagInfoCommand
      {
         return _instance || (_instance = new ClanNameTagInfoCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 8782;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 8;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.tag = param1.readUTF();
         this.id = param1.readInt();
         this.id = this.id << 2 % 32 | this.id >>> 32 - 2 % 32;
         this.name = param1.readUTF();
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(8782);
         param1.writeUTF(this.tag);
         param1.writeInt(this.id >>> 2 % 32 | this.id << 32 - 2 % 32);
         param1.writeUTF(this.name);
      }
   }
}

