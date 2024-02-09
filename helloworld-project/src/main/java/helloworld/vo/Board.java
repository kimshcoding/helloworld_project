package helloworld.vo;

public class Board extends Member {
	private int bno;
	private String btitle;
	private String bcontent;
	private int bhit;
	private String rdate;
	private String mdate;
	private char delyn;
	private char type;
	private int mno;
	
	
	 // 예시: 수정 여부를 나타내는 필드
    private boolean modified;

    // 예시: isModified() 메소드
    public boolean isModified() {
        return modified;
    }

    // 예시: modified 필드의 setter
    public void setModified(boolean modified) {
        this.modified = modified;
    }
	
    
    
	public int getBno() {
		return bno;
	}
	public void setBno(int bno) {
		this.bno = bno;
	}
	public String getBtitle() {
		return btitle;
	}
	public void setBtitle(String btitle) {
		this.btitle = btitle;
	}
	public String getBcontent() {
		return bcontent;
	}
	public void setBcontent(String bcontent) {
		this.bcontent = bcontent;
	}
	public int getBhit() {
		return bhit;
	}
	public void setBhit(int bhit) {
		this.bhit = bhit;
	}
	public String getRdate() {
		return rdate;
	}
	public void setRdate(String rdate) {
		this.rdate = rdate;
	}
	public String getMdate() {
		return mdate;
	}
	public void setMdate(String mdate) {
		this.mdate = mdate;
	}
	public char getDelyn() {
		return delyn;
	}
	public void setDelyn(char delyn) {
		this.delyn = delyn;
	}
	public char getType() {
		return type;
	}
	public void setType(char type) {
		this.type = type;
	}
	public int getMno() {
		return mno;
	}
	public void setMno(int mno) {
		this.mno = mno;
	}

	
}
