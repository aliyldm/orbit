package net.bigpoint.darkorbit.com.module.porting.clan
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class ClanEditDiploOfferRequest implements IModule
   {
      
      private static var _instance:ClanEditDiploOfferRequest;
      
      public var status:String = "";
      
      public var diploId:int = 0;
      
      public function ClanEditDiploOfferRequest(param1:int = 0, param2:String = "")
      {
         super();
         this.status = param2;
         this.diploId = param1;
      }
      
      public static function get instance() : ClanEditDiploOfferRequest
      {
         return _instance || (_instance = new ClanEditDiploOfferRequest());
      }
      
      public function getLibcomModuleId() : int
      {
         return -5174;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 6;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.status = param1.readUTF();
         this.diploId = param1.readInt();
         this.diploId = this.diploId << 7 % 32 | this.diploId >>> 32 - 7 % 32;
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(-5174);
         param1.writeUTF(this.status);
         param1.writeInt(this.diploId >>> 7 % 32 | this.diploId << 32 - 7 % 32);
      }
   }
}

