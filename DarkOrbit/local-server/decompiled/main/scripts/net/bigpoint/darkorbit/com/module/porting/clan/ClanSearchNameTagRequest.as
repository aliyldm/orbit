package net.bigpoint.darkorbit.com.module.porting.clan
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class ClanSearchNameTagRequest implements IModule
   {
      
      private static var _instance:ClanSearchNameTagRequest;
      
      public var lookup:String = "";
      
      public function ClanSearchNameTagRequest(param1:String = "")
      {
         super();
         this.lookup = param1;
      }
      
      public static function get instance() : ClanSearchNameTagRequest
      {
         return _instance || (_instance = new ClanSearchNameTagRequest());
      }
      
      public function getLibcomModuleId() : int
      {
         return 13300;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 2;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.lookup = param1.readUTF();
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(13300);
         param1.writeUTF(this.lookup);
      }
   }
}

