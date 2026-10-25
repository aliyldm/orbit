package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   
   public class WildcardMessageModule extends MessageModule
   {
      
      private static var _instance:WildcardMessageModule;
      
      public var message:MessageKeyListWildcardModule;
      
      public function WildcardMessageModule(param1:MessageKeyListWildcardModule = null)
      {
         super();
         if(param1 == null)
         {
            this.message = new MessageKeyListWildcardModule();
         }
         else
         {
            this.message = param1;
         }
      }
      
      public static function get instance() : WildcardMessageModule
      {
         return _instance || (_instance = new WildcardMessageModule());
      }
      
      override public function getLibcomModuleId() : int
      {
         return -18328;
      }
      
      override public function getLibcomModuleEstimatedLength() : int
      {
         return 0;
      }
      
      override public function read(param1:IDataInput) : void
      {
         param1.readShort();
         super.read(param1);
         this.message = MessageKeyListWildcardModule(ModuleFactory.get().createInstance(param1.readShort()));
         if(null != this.message)
         {
            this.message.read(param1);
         }
      }
      
      override public function write(param1:IDataOutput) : void
      {
         param1.writeShort(-18328);
         super.write(param1);
         if(null != this.message)
         {
            this.message.write(param1);
         }
         else
         {
            param1.writeShort(0);
         }
      }
   }
}

