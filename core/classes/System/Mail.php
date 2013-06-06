<?php

/**
 * @Nutmouse CMS
 * @Version: 0.2
 * @Copyright: BurrDesign
 * @Date: 2012-06-04
 *
 * @Beschreibung:
 *		Hilfs-Klasse zum vorbereiten und versenden von
 *		Mails
 */
 
class Mail {

	private $mail_from = array();
	private $mail_to = array();
	private $mail_cc = array();
	private $mail_bcc = array();
	private $mail_reply = null;
	
	private $mail_subject = null;
	private $mail_text = null;
	
	private $mail_header = null;
	private $mail_content = null;
	
	private $mail_attachments = array();
	private $mime_boundary = null;
	
	public function __construct($boundary=""){
		if(empty($boundary)){
			$boundary = md5(rand(0,100) . time());
		}
		$this->mime_boundary = "-----=" . $boundary;
	}
	
	private function addAddress($addresses, $new){
		if(!is_array($addresses)){
			return;
		}
		if(is_array($new)){
			array_merge($addresses, $new);
		} else {
			$addresses[] = $new;
		}
		$addresses = array_unique($addresses);
		array_filter($addresses);
		return $addresses;
	}
	
	private function removeAddress($addresses, $remove){
		if(is_array($remove)){
			foreach($remove as $r){
				if(in_array($r, $addresses)){
					$pos = array_search($r, $addresses);
					unset($addresses[$pos]);
				}
			}
		} else {
			if(in_array($remove, $addresses)){
				$pos = array_search($remove, $addresses);
				unset($addresses[$pos]);
			}
		}
		return $addresses;
	}
	
	public function addFrom($from){
		$this->mail_from = $this->addAddress($this->mail_from, $from);
	}
	
	public function removeFrom($remove){
		$this->mail_from = $this->removeAddress($this->mail_from, $remove);
	}
	
	public function addTo($to){
		$this->mail_to = $this->addAddress($this->mail_to, $to);
	}
	
	public function removeTo($remove){
		$this->mail_to = $this->removeAddress($this->mail_to, $remove);
	}
	
	public function addCc($cc){
		$this->mail_cc = $this->addAddress($this->mail_cc, $cc);
	}
	
	public function removeCc($remove){
		$this->mail_cc = $this->removeAddress($this->mail_cc, $remove);
	}
	
	public function addBcc($bcc){
		$this->mail_bcc = $this->addAddress($this->mail_bcc, $bcc);
	}
	
	public function removeBcc($remove){
		$this->mail_bcc = $this->removeAddress($this->mail_bcc, $remove);
	}
	
	public function addAttachment($attachment){
		if(!is_array($attachment)){
			return;
		}
		$this->mail_attachments[] = $attachment;
		$this->mail_attachments = array_unique($this->mail_attachments);
		array_filter($this->mail_attachments);
	}
	
	public function removeAttachment($remove){
		if(in_array($remove['filepath'], $this->mail_attachments)){
			$pos = array_search($remove['filepath'], $this->mail_attachments);
			unset($this->mail_attachments[$pos]);
		}
	}
	
	public function setReply($reply){
		$this->mail_reply = $reply;
	}
	
	public function setSubject($subject){
		$this->mail_subject = $subject;
	}
	
	public function setText($text){
		$this->mail_text = $text;
	}
	
	private function createHeader(){	
		if($this->mail_identkey) $mime_boundary = "-----=" . $this->mail_identkey;
		$this->mail_header  = "From:";
		$sep = "";
		if(count($this->mail_from) > 0){
			foreach($this->mail_from as $from){
				$this->mail_header .= "{$sep}{$from}";
			}
		}
		$this->mail_header .= "\n";
		if($this->mail_reply){
			$this->mail_header .= "Reply-To: {$this->mail_reply}\r\n";
		}
		if(count($this->mail_cc) > 0){
			$this->mail_header .= "Cc: ";
			$sep = "";
			foreach($this->mail_cc as $cc){
				$this->mail_header .= "{$sep}{$cc}";
			}
			$this->mail_header .= "\r\n";
		}
		if(count($this->mail_bcc) > 0){ 
			$this->mail_header .= "Bcc: ";
			$sep = "";
			foreach($this->mail_bcc as $bcc){
				$this->mail_header .= "{$sep}{$bcc}";
			}
			$this->mail_header .= "\r\n";
		}
		$this->mail_header .= "MIME-Version: 1.0\r\n";
		$this->mail_header .= "Content-Type: multipart/mixed;\r\n";
		$this->mail_header .= " boundary=\"{$this->mime_boundary}\"\r\n";
	}
	
	private function createContent(){
		$this->mail_content = "This is a multi-part message in MIME format.\r\n\r\n";
		$this->mail_content.= "--{$this->mime_boundary}\r\n";
		$this->mail_content .= "Content-Type: text/html charset=\"iso-8859-1\"\r\n";
		$this->mail_content .= "Content-Transfer-Encoding: 8bit\r\n\r\n";
		$this->mail_content .= $this->mail_text . "\r\n";
		
		foreach($this->mail_attachments as $attachment){
			if(is_file($attachment['filepath'])){
				$filepath = $attachment['filepath'];
				$filename = $attachment['filename'];
				if(empty($filename)){
					$filename = $filepath;
				}
				$filesize = filesize($filepath);
				$filetype = mime_content_type($filepath);
				$data = chunk_split(base64_encode(implode(file($filepath))));
				$this->mail_content .= "--".$this->mime_boundary."\r\n";
				$this->mail_content .= "Content-Disposition: attachment;\r\n";
				$this->mail_content .= "\tfilename=\"{$filename}\";\r\n";
				$this->mail_content .= "Content-Length: .{$filesize};\r\n";
				$this->mail_content .= "Content-Type: {$filetype}; name=\"{$filename}\"\r\n";
				$this->mail_content .= "Content-Transfer-Encoding: base64\r\n\r\n";
				$this->mail_content .= $data . "\r\n"; 
			}
		}
	}
	
	public function send(){
		if(count($this->mail_to) <= 0){
			return;
		}
		$this->createHeader();
		$this->createContent();
		$to = "";
		$sep = "";
		foreach($this->mail_to as $address){
			$to .= "{$sep}{$address}";
		}
		mail($to, $this->mail_subject, $this->mail_content, $this->mail_header);
	}
	
}